require 'pathname'
require 'tempfile'
require 'tmpdir'

# Extension of Pathname with helpful methods and fixes
class FSPath < Pathname
  # Extension of Tempfile returning instance of provided class for path
  class Tempfile < ::Tempfile
    # Eats first argument which must be a class, and calls super
    def initialize(path_klass, *args)
      unless path_klass.is_a?(Class)
        fail ArgumentError, "#{path_klass.inspect} is not a class"
      end
      @path_klass = path_klass
      super(*args)
    end

    # Returns path wrapped in class provided in initialize
    def path
      @path_klass.new(super)
    end

    # Fixes using appropriate initializer for jruby in 1.8 mode, also returns
    # result of block in ruby 1.8
    def self.open(*args)
      tempfile = new(*args)

      if block_given?
        begin
          yield(tempfile)
        ensure
          tempfile.close
        end
      else
        tempfile
      end
    end
  end

  class << self
    # Return current user home path if called without argument.
    # If called with argument return specified user home path.
    def ~(name = nil)
      new(File.expand_path("~#{name}"))
    end

    # Returns common dir for paths
    def common_dir(*paths)
      paths.map do |path|
        new(path).ascendants.drop(1)
      end.inject(:&).first
    end

    # Returns or yields temp file created by Tempfile.new with path returning
    # FSPath
    def temp_file(*args, &block)
      args = %w[f] if args.empty?
      Tempfile.open(self, *args, &block)
    end

    # Returns or yields path as FSPath of temp file created by Tempfile.new
    # WARNING: loosing reference to returned object will remove file on nearest
    # GC run
    def temp_file_path(*args)
      if block_given?
        temp_file(*args) do |file|
          yield file.path
        end
      else
        file = temp_file(*args)
        file.close
        path = file.path
        path.instance_variable_set(:@__temp_file, file)
        path
      end
    end

    # Returns or yields FSPath with temp directory created by Dir.mktmpdir
    def temp_dir(*args)
      if block_given?
        Dir.mktmpdir(*args) do |dir|
          yield new(dir)
        end
      else
        new(Dir.mktmpdir(*args))
      end
    end
  end

  # Join paths using File.join
  def /(other)
    self.class.new(File.join(@path, other.to_s))
  end

  unless (new('a') + 'b').is_a?(self)
    # Fixing Pathname#+
    def +(other)
      self.class.new(super)
    end
  end

  # Fixing Pathname.relative_path_from
  def relative_path_from(other)
    self.class.new(super(self.class.new(other)))
  end

  # Write data to file
  def write(data)
    open('wb') do |f|
      f.write(data)
    end
  end

  # Append data to file
  def append(data)
    open('ab') do |f|
      f.write(data)
    end
  end

  # Escape characters in glob pattern
  def escape_glob
    self.class.new(escape_glob_string)
  end

  # Expand glob
  def glob(*args, &block)
    flags = args.last.is_a?(Fixnum) ? args.pop : nil
    args = [File.join(escape_glob_string, *args)]
    args << flags if flags
    self.class.glob(*args, &block)
  end

  # Returns list of elements in the given path in ascending order
  def ascendants
    paths = []
    path = @path
    paths << self
    while (r = chop_basename(path))
      path = r.first
      break if path.empty?
      paths << self.class.new(del_trailing_separator(path))
    end
    paths
  end

  # Returns list of elements in the given path in descending order
  def descendants
    ascendants.reverse
  end

  # Iterates over and yields each element in the given path in ascending order
  def ascend(&block)
    paths = ascendants
    paths.each(&block) if block
    paths
  end

  # Iterates over and yields each element in the given path in descending order
  def descend(&block)
    paths = descendants
    paths.each(&block) if block
    paths
  end

  # Returns path parts
  def parts
    split_names(@path).flatten
  end

  unless pwd.is_a?(self)
    # Fixing glob
    def self.glob(*args)
      if block_given?
        super{ |f| yield new(f) }
      else
        super.map{ |f| new(f) }
      end
    end

    # Fixing getwd
    def self.getwd
      new(super)
    end

    # Fixing pwd
    def self.pwd
      new(super)
    end

    # Fixing basename
    def basename(*args)
      self.class.new(super)
    end

    # Fixing dirname
    def dirname
      self.class.new(super)
    end

    # Fixing expand_path
    def expand_path(*args)
      self.class.new(super)
    end

    # Fixing split
    def split
      super.map{ |f| self.class.new(f) }
    end

    # Fixing sub
    def sub(pattern, *rest, &block)
      self.class.new(super)
    end

    if Pathname.method_defined?(:sub_ext)
      # Fixing sub_ext
      def sub_ext(ext)
        self.class.new(super)
      end
    end

    # Fixing realpath
    def realpath
      self.class.new(super)
    end

    if Pathname.method_defined?(:realdirpath)
      # Fixing realdirpath
      def realdirpath
        self.class.new(super)
      end
    end

    # Fixing readlink
    def readlink
      self.class.new(super)
    end

    # Fixing each_entry
    def each_entry
      super{ |f| yield self.class.new(f) }
    end

    # Fixing entries
    def entries
      super.map{ |f| self.class.new(f) }
    end
  end

  unless new('a').inspect.include?('FSPath')
    # Fixing inspect
    def inspect
      "#<#{self.class}:#{@path}>"
    end
  end

private

  def escape_glob_string
    @path.gsub(/([\*\?\[\]\{\}])/, '\\\\\1')
  end
end

# Add FSPath method as alias to FSPath.new
module Kernel
  # FSPath(path) method
  define_method :FSPath do |path|
    FSPath.new(path)
  end
  private :FSPath
end
