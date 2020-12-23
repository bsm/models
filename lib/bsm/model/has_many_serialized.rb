require 'bsm/model/coders/json_column'

module Bsm::Model::HasManySerialized
  extend ActiveSupport::Concern

  module ClassMethods
    def has_many_serialized(name, scope = nil, options = {})
      Builder.build(self, name, scope, options)
    end
  end

  class Builder < ActiveRecord::Associations::Builder::CollectionAssociation
    def self.build(model, name, *)
      model.serialize "#{name.to_s.singularize}_ids", ::Bsm::Model::Coders::JsonColumn.new(Array)
      super
    end

    def self.define_accessors(model, reflection)
      mixin = model.generated_association_methods
      name  = reflection.name
      klass = reflection.klass
      attribute_name = "#{name.to_s.singularize}_ids"

      mixin.redefine_method(name) do
        klass.where(klass.primary_key => send(attribute_name))
      end

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

    def self.macro
      :has_many
    end

    def valid_dependent_options
      []
    end
  end
end
