module Bsm::Model::Deletable
  extend ActiveSupport::Concern

  included do
    before_destroy :check_deletable?
  end

  def deletable?
    raise NotImplementedError
  end

  private

  def check_deletable?
    throw :abort unless deletable?
  end

end
