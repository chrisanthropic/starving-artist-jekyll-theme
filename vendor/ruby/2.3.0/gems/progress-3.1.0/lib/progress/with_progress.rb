require 'progress'
require 'stringio'

class Progress
  # Handling with_progress
  class WithProgress
    attr_reader :enum, :title
    alias_method :enumerable, :enum

    # If block given run each on instance otherwise return instance
    def self.new(*args, &block)
      block ? super.each(&block) : super
    end

    # initialize with object responding to each, title and optional length
    # if block is provided, it is passed to each
    def initialize(enum, title = nil, length = nil)
      @enum, @title, @length = enum, title, length
    end

    # returns self but changes title
    def with_progress(title = nil, length = nil, &block)
      self.class.new(@enum, title, length || @length, &block)
    end

    # befriend with in_threads gem
    def in_threads(*args, &block)
      @enum.in_threads(*args).with_progress(@title, @length, &block)
    rescue
      super
    end

    def respond_to?(method, include_private = false)
      enumerable_method?(method) || super
    end

    def method_missing(method, *args, &block)
      if enumerable_method?(method)
        run(method, *args, &block)
      else
        super(method, *args, &block)
      end
    end

  protected

    def enumerable_method?(method)
      method == :each || Enumerable.method_defined?(method)
    end

    def run(method, *args, &block)
      case
      when !block
        run_without_block(@enum, method, *args)
      when @length
        run_with_length(@enum, @length, method, *args, &block)
      when @enum.is_a?(String)
        run_for_string(method, *args, &block)
      when io?
        run_for_io(method, *args, &block)
      when defined?(CSV::Reader) && @enum.is_a?(CSV::Reader)
        run_for_ruby18_csv(method, *args, &block)
      else
        run_with_length(@enum, enum_length(@enum), method, *args, &block)
      end
    end

    def run_for_string(method, *args, &block)
      with_substitute(StringIO.new(@enum)) do |io|
        run_with_pos(io, method, *args, &block)
      end
    end

    def run_for_io(method, *args, &block)
      if io_pos?
        run_with_pos(@enum, method, *args, &block)
      else
        warn "Progress: can't get #{@enum.class} pos, collecting elements"
        with_substitute(@enum.to_a) do |lines|
          run_with_length(lines, lines.length, method, *args, &block)
        end
      end
    end

    def run_for_ruby18_csv(method, *args, &block)
      warn "Progress: #{@enum.class} doesn't expose IO, collecting elements"
      with_substitute(@enum.to_a) do |lines|
        run_with_length(lines, lines.length, method, *args, &block)
      end
    end

    def run_without_block(enum, method, *args)
      Progress.start(@title) do
        Progress.step do
          enum.send(method, *args)
        end
      end
    end

    def run_with_length(enum, length, method, *args, &block)
      Progress.start(@title, length) do
        enum.send(method, *args) do |*block_args|
          Progress.step do
            block.call(*block_args)
          end
        end
      end
    end

    def run_with_pos(io, method, *args, &block)
      size = io.respond_to?(:size) ? io.size : io.stat.size
      Progress.start(@title, size) do
        io.send(method, *args) do |*block_args|
          Progress.set(io.pos) do
            block.call(*block_args)
          end
        end
      end
    end

    def with_substitute(enum)
      result = yield enum
      result.eql?(enum) ? @enum : result
    end

    def io?
      @enum.respond_to?(:pos) &&
        (@enum.respond_to?(:size) || @enum.respond_to?(:stat))
    end

    def io_pos?
      @enum.pos; true
    rescue Errno::ESPIPE
      false
    end

    def enum_length(enum)
      enum.respond_to?(:size) && enum.size ||
        enum.respond_to?(:length) && enum.length ||
        enum.count
    end
  end
end
