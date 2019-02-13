module Bsm::Model::Abstract
  extend ActiveSupport::Concern

  included do
    validate :must_not_be_abstract

    define_method :must_not_be_abstract do
      errors.add :base, :abstract if abstract_model_instance?
    end

    class_eval <<-METHOD, __FILE__, __LINE__ + 1
      def abstract_model_instance?
        self.class >= ::#{name}
      end
    METHOD

    protected :must_not_be_abstract, :abstract_model_instance?
  end
end
