module Bsm::Model::StiConvertable
  extend ActiveSupport::Concern

  included do
    include Bsm::Model::EagerDescendants

    class_eval <<-METHOD, __FILE__, __LINE__ + 1
      def self.real_type? # def real_type?
        self < ::#{name}  #   self.class < ::ThisModel
      end                 # end
    METHOD
  end

  def self.scoping(*)
    yield
  end

  module ClassMethods
    # @Override: Allow to specify a kind
    def new(attributes = nil, *args, &block)
      kind = attributes.delete(:kind) { attributes.delete('kind') } if attributes.respond_to?(:delete)
      return super if real_type?

      klass = real_descendants.find {|k| k.kind == kind } || fallback_descendant
      return super if klass == self

      Bsm::Model::StiConvertable.scoping(klass, current_scope) { klass.new(attributes, *args, &block) }
    end

    def real_descendants
      descendants.select(&:real_type?)
    end

    def fallback_descendant
      self
    end

    def kind
      name.demodulize.underscore
    end
  end

  delegate :kind, to: 'self.class'

  def kind=(_val); end
end
