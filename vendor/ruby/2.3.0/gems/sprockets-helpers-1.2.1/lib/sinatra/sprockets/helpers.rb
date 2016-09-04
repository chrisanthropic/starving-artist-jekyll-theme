require 'sinatra/base'
require 'sprockets/helpers'

module Sinatra
  module Sprockets
    module Helpers
      def self.registered(app)
        app.helpers ::Sprockets::Helpers
        app.configure_sprockets_helpers
      end

      def configure_sprockets_helpers(&block)
        ::Sprockets::Helpers.configure do |helpers|
          with_setting(:sprockets) { |value| helpers.environment = value }
          with_setting(:public_folder) { |value| helpers.public_path = value }
          with_setting(:digest_assets) { |value| helpers.digest = value }
          with_setting(:assets_prefix) { |value| helpers.prefix = value }
        end
        ::Sprockets::Helpers.configure(&block) if block_given?
      end

      private

        def with_setting(name, &block)
          return unless settings.respond_to?(name)

          value = settings.__send__(name)
          yield value unless value.nil?
        end
    end
  end

  register Sprockets::Helpers
end
