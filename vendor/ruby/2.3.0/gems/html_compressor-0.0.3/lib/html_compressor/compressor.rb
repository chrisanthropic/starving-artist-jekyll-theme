require "popen4"
require "shellwords"
require "stringio"

module HtmlCompressor #:nodoc:
  class Compressor
    VERSION = "0.0.1"

    class Error < StandardError; end
    class OptionError   < Error; end
    class RuntimeError  < Error; end

    attr_reader :options

    def self.default_options #:nodoc:
      { :charset => "utf-8", :line_break => nil }
    end

    def self.compressor_type #:nodoc:
      raise Error, "create a HtmlCompressor instead"
    end

    def initialize(options = {}) #:nodoc:
      @options = self.class.default_options.merge(options)
      @command = [path_to_java, "-jar", path_to_jar_file, *(command_option_for_type + command_options)]
    end

    def command #:nodoc:
      @command.map { |word| Shellwords.escape(word) }.join(" ")
    end

    # Compress a stream or string of code with HTML Compressor. (A stream is
    # any object that responds to +read+ and +close+ like an IO.) If a block
    # is given, you can read the compressed code from the block's argument.
    # Otherwise, +compress+ returns a string of compressed code.
    #
    # ==== Example: Compress HTML
    #   compressor = HtmlCompressor::HtmlCompressor.new
    #   compressor.compress(<<-END_HTML)
    #   <html>     
    #     <head>
    #     </head>
    #     <body>
    #     fdgdfgf
    #
    #
    #     </body>
    #   </html>  
    #   END_HTML
    #   # => "<html><head></head><body>fdgdfgf</body></html>"
    #
    def compress(stream_or_string)
      streamify(stream_or_string) do |stream|
        output = true
        status = POpen4.popen4(command, "b") do |stdout, stderr, stdin, pid|
          begin
            stdin.binmode
            transfer(stream, stdin)

            if block_given?
              yield stdout
            else
              output = stdout.read
            end

          rescue Exception => e
            raise RuntimeError, "compression failed"
          end
        end

        if status.exitstatus.zero?
          output
        else
          raise RuntimeError, "compression failed"
        end
      end
    end

    private
      def command_options
        options.inject([]) do |command_options, (name, argument)|
          method = begin
            method(:"command_option_for_#{name}")
          rescue NameError
            raise OptionError, "undefined option #{name.inspect}"
          end

          command_options.concat(method.call(argument))
        end
      end

      def path_to_java
        options.delete(:java) || "java"
      end

      def path_to_jar_file
        options.delete(:jar_file) || File.join(File.dirname(__FILE__), *%w".. htmlcompressor-1.3.1.jar")
      end

      def streamify(stream_or_string)
        if stream_or_string.respond_to?(:read)
          yield stream_or_string
        else
          yield StringIO.new(stream_or_string.to_s)
        end
      end

      def transfer(from_stream, to_stream)
        while buffer = from_stream.read(4096)
          to_stream.write(buffer)
        end
        from_stream.close
        to_stream.close
      end

      def command_option_for_type
        ["--type", self.class.compressor_type.to_s]
      end

      def command_option_for_charset(charset)
        ["--charset", charset.to_s]
      end

      def command_option_for_line_break(line_break)
        line_break ? ["--line-break", line_break.to_s] : []
      end
  end
end
