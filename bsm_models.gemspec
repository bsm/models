# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.name        = "bsm_models"
  s.summary     = "BSM's very custom model extensions"
  s.description = ""
  s.version     = '0.2.1'

  s.authors     = ["Dimitrij Denissenko"]
  s.email       = "dimitrij@blacksquaremedia.com"
  s.homepage    = "https://github.com/bsm/models"

  s.require_path = 'lib'
  s.files        = Dir['README.markdown', 'lib/**/*']

  s.add_dependency "abstract"
  s.add_dependency "rails", ">= 3.0.0", "<= 3.2.0"
end
