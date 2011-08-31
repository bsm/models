module Bsm::Model::Abstract
  extend ActiveSupport::Concern

  included do
    validate :must_not_be_abstract

    class_eval <<-END_EVAL
      def must_not_be_abstract
        errors.add :base, :abstract unless self.class < ::#{self.name}
      end
    END_EVAL
    protected :must_not_be_abstract
  end

end