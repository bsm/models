require "rails"

module Bsm
  module Model
    autoload :Abstract, 'bsm/model/abstract'
    autoload :Editable, 'bsm/model/editable'
    autoload :Deletable, 'bsm/model/deletable'
  end

  class Railtie < ::Rails::Railtie
    require 'active_support/i18n'
    I18n.load_path << File.expand_path('../bsm/model/locale/en.yml', __FILE__)
  end
end