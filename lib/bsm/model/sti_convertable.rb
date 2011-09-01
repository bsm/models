module Bsm::Model::StiConvertable
  extend ActiveSupport::Concern

  included do
    include Bsm::Model::EagerDescendants
    class_eval <<-METHOD, __FILE__, __LINE__ + 1
      def self.real_type?
        self < ::#{name}
      end
    METHOD
  end

  module ClassMethods

    # @Override: Allow to specify a kind
    def new(attributes = nil, *args, &block)
      kind  = (attributes = attributes.with_indifferent_access).delete(:kind) if attributes.is_a?(Hash)
      klass = real_descendants.find {|k| k.kind == kind }
      return super unless klass

      klass.with_scope(respond_to?(:current_scope) ? current_scope : current_scoped_methods) do # AR 3.0 compatibility
        klass.new(attributes, *args, &block)
      end
    end

    def real_descendants
      descendants.select(&:real_type?)
    end

    def kind
      name.demodulize.underscore
    end

  end

  delegate :kind, :to => 'self.class'
end
