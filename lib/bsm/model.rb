require 'rails'

module Bsm
  module Model
    autoload :Abstract, 'bsm/model/abstract'
    autoload :Editable, 'bsm/model/editable'
    autoload :Deletable, 'bsm/model/deletable'
    autoload :EagerDescendants, 'bsm/model/eager_descendants'
    autoload :StiConvertable, 'bsm/model/sti_convertable'
    autoload :HasManySerialized, 'bsm/model/has_many_serialized'
  end

  class Railtie < ::Rails::Railtie
    require 'active_support/i18n'
    I18n.load_path << File.expand_path('../model/locale/en.yml', __FILE__)
  end
end