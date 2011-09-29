module Bsm::Model::Abstract
  extend ActiveSupport::Concern

  included do
    validate :must_not_be_abstract

    define_method :must_not_be_abstract do
      errors.add :base, :abstract if abstract_model_instance?
    end

    class_eval <<-END_EVAL
      def abstract_model_instance?
        self.class >= ::#{self.name}
      end
    END_EVAL

    protected :must_not_be_abstract, :abstract_model_instance?
  end

end