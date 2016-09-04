require "popen4"
require "shellwords"
require "stringio"

module HtmlCompressor #:nodoc:
  class HtmlCompressor < Compressor
    def self.compressor_type #:nodoc:
      "html"
    end

    def self.default_options #:nodoc:
      super.merge(
        :compress_js => true,
        :compress_css => true
      )
    end

    def initialize(options = {})
      super
    end

    private
      def command_option_for_comments(comments)
        comments ? [] : ["--preserve-comments"]
      end
      
      def command_option_for_multi_spaces(multi_spaces)
        multi_spaces ? [] : ["--preserve-multi-spaces"]
      end
      
      def command_option_for_intertag_spaces(intertag_spaces)
        intertag_spaces ? [] : ["--remove-intertag-spaces"]
      end
      
      def command_option_for_compress_js(compress_js)
        compress_js ? [] : ["--compress-js"]
      end
      
      def command_option_for_compress_css(compress_css)
        compress_css ? [] : ["--compress-css"]
      end
  end
end
