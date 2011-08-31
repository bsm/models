module Bsm::Model::Editable
  extend ActiveSupport::Concern

  included do
    validate :must_be_editable, :on => :update
  end

  def editable?
    not_implemented
  end

  def immutable?
    !editable?
  end

  protected

    def must_be_editable
      errors.add :base, :immutable if immutable?
    end

end