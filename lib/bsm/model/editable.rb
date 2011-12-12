module Bsm::Model::Editable
  extend ActiveSupport::Concern

  included do
    validate      :must_be_editable, :on => :update
    attr_accessor :force_editable
  end

  def editable?
    not_implemented
  end

  def immutable?
    !force_editable && !editable?
  end

  protected

    def must_be_editable
      errors.add :base, :immutable if immutable?
    end

end