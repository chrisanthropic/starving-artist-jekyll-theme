require 'sprockets'
require 'sprockets-helpers'
require 'sinatra/base'
require 'sinatra/sprockets/helpers'
require 'test_construct'
require 'pathname'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include TestConstruct::Helpers

  # Disable old `should` syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Returns a Sprockets environment. Automatically
  # appends the 'assets' path if available.
  def env
    @env ||= Sprockets::Environment.new.tap do |env|
      env.append_path 'assets' if File.directory?('assets')
    end
  end

  # Returns a fresh context, that can be used to test helpers.
  def context(logical_path = 'application.js', pathname = nil)
    pathname ||= Pathname.new(File.join('assets', logical_path)).expand_path

    if Sprockets::Helpers.are_using_sprockets_3
      env.context_class.new(
        :environment => env,
        :name => logical_path,
        :filename => pathname,
        :metadata => {}
      )
    else
      env.context_class.new env, logical_path, pathname
    end
  end

  # Exemplary file system layout for usage in test-construct
  def assets_layout(construct)
    lambda { |c|
      c.file('assets/main.js') do |f|
        f << "//= require a\n"
        f << "//= require b\n"
      end
      c.file('assets/a.js')
      c.file('assets/b.js')

      c.file('assets/main.css') do |f|
        f << "/*\n"
        f << "*= require a\n"
        f << "*= require b\n"
        f << "*/\n"
      end
      c.file('assets/a.css')
      c.file('assets/b.css')
    }.call(construct)
  end
end
