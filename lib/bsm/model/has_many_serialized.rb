require 'bsm/model/coders/json_column'

module Bsm::Model::HasManySerialized
  extend ActiveSupport::Concern

  module ClassMethods

    def has_many_serialized(name, options = {})
      Builder.build(self, name.to_sym, options)
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
        model.serialize attribute_name, ::Bsm::Model::Coders::JsonColumn.new(Array)
      end

      def define_readers
        name, attribute_name, klass = self.name, self.attribute_name, self.klass

        model.redefine_method(name) do
          klass.where(klass.primary_key => send(attribute_name))
        end

        model.redefine_method(attribute_name) do
          read_attribute(attribute_name)
        end if ActiveRecord::VERSION::STRING < "3.2.0"
      end

      def define_writers
        name, attribute_name, klass = self.name, self.attribute_name, self.klass

        model.redefine_method("#{name}=") do |records|
          records = Array.wrap(records)
          records.each do |record|
            next if record.is_a?(klass)
            raise ActiveRecord::AssociationTypeMismatch, "#{klass.name} expected, got #{record.class}"
          end
          write_attribute attribute_name, records.map(&:id).sort
        end

        model.redefine_method("#{attribute_name}=") do |values|
          send "#{name}=", klass.where(klass.primary_key => Array.wrap(values)).select(:id).to_a.sort
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