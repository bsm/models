source "http://rubygems.org"

gemspec
gem "activerecord", "~> 3.0.0"

group :test do
  gem "rspec"
  gem "sqlite3-ruby"
  gem "shoulda-matchers"
end