# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

source "https://rubygems.org"
gem "rake", :require => false
gem "addressable"
gem "i18n"
gemspec

group :test do
  gem "liquid", :require => false
  gem "codeclimate-test-reporter", :require => false
  gem "luna-rspec-formatters", :require => false
  gem "rspec", :require => false
end

group :development do
  gem "luna-rubocop-formatters", :require => false
  gem "rubocop", :github => "bbatsov/rubocop", :require => false
  gem "pry", :require => false
end
