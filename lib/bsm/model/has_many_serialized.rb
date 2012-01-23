module Bsm::Model::HasManySerialized
  extend ActiveSupport::Concern

  module ClassMethods

    def has_many_serialized(name, options = {})
      Builder.build(self, name.to_sym, options)
    end

  end

  class Coder

    def dump(obj)
      ActiveSupport::JSON.encode(obj)
    end

    def load(value)
      return [] if value.nil?
      return value unless value.is_a?(String)

      obj = ActiveSupport::JSON.decode(value) || []
      unless obj.is_a?(Array)
        raise ActiveRecord::SerializationTypeMismatch, "Attribute was supposed to be an Array, but was a #{obj.class}"
      end
      obj
    end

  end

  class Builder < ActiveRecord::Associations::Builder::Association

    def build
      validate_options
      serialize_attribute
      define_accessors
    end

    protected

      def serialize_attribute
        model.serialize attribute_name, Coder.new
      end

      def define_readers
        name, attribute_name, klass = self.name, self.attribute_name, self.klass

        model.redefine_method(name) do
          klass.where(klass.primary_key => send(attribute_name))
        end

        model.redefine_method(attribute_name) do
          value = read_attribute(attribute_name)
          value.respond_to?(:unserialized_value) ? value.unserialized_value : value
        end
      end

      def define_writers
        name, attribute_name, klass = self.name, self.attribute_name, self.klass

        model.redefine_method("#{name}=") do |records|
          records = Array.wrap(records)
          records.each do |record|
            next if record.is_a?(klass)
            raise ActiveRecord::AssociationTypeMismatch, "#{klass.name} expected, got #{record.class}"
          end
          write_attribute attribute_name, records.map(&:id)
        end

        model.redefine_method("#{attribute_name}=") do |values|
          send "#{name}=", klass.where(klass.primary_key => Array.wrap(values)).to_a
        end
      end

      def attribute_name
        @attribute_name ||= "#{name.to_s.singularize}_ids"
      end

      def klass
        @klass ||= class_name.constantize
      end

      def class_name
        @class_name ||= options[:class_name] || name.to_s.singularize.camelize
      end

  end
end