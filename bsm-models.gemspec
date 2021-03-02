Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.6'

  s.name        = 'bsm-models'
  s.summary     = "BSM's very custom model extensions"
  s.description = ''
  s.version     = '0.12.2'

  s.authors     = ['Dimitrij Denissenko']
  s.email       = 'dimitrij@blacksquaremedia.com'
  s.homepage    = 'https://github.com/bsm/models'

  s.require_path = 'lib'
  s.files        = Dir['README.markdown', 'lib/**/*']

  s.add_dependency 'activerecord', '>= 6.0'

  s.add_development_dependency 'railties'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'rubocop-bsm'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'sqlite3'
end
