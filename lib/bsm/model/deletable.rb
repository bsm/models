module Bsm::Model::Deletable
  extend ActiveSupport::Concern

  included do
    before_destroy :deletable?
  end

  def deletable?
    not_implemented
  end

end
