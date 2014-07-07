# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.0.0'
  s.required_rubygems_version = ">= 1.8.0"

  s.name        = "bsm-models"
  s.summary     = "BSM's very custom model extensions"
  s.description = ""
  s.version     = '0.8.0'

  s.authors     = ["Dimitrij Denissenko"]
  s.email       = "dimitrij@blacksquaremedia.com"
  s.homepage    = "https://github.com/bsm/models"

  s.require_path = 'lib'
  s.files        = Dir['README.markdown', 'lib/**/*']

  s.add_dependency "abstract"
  s.add_dependency "activerecord", ">= 4.1.0", "< 4.2.0"
  s.add_dependency "railties", ">= 4.1.0", "< 4.2.0"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-its"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "shoulda-matchers"

end
