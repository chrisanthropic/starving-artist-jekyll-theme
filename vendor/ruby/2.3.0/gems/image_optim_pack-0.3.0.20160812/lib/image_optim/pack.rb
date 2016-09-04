require 'fspath'
require 'image_optim/bin_resolver/bin'

class ImageOptim
  # Handle selection of directory with binaries most suitable for current
  # operating system and architecture
  module Pack
    # Path to binary, last two parts are expect to be os/arch
    class Path
      # Path provided to initialize as FSPath
      attr_reader :path

      # Intended os
      attr_reader :os

      # Inteded architecture
      attr_reader :arch

      # Receive path, use last part for arch and last but one part for os
      def initialize(path)
        @path = FSPath(path)
        @os, @arch = @path.basename.to_s.split('-', 2)
      end

      # Return path converted to string
      def to_s
        path.to_s
      end

      # Cached array of BinResolver::Bin instances for each bin
      def bins
        @bins ||= bin_paths.map do |bin_path|
          BinResolver::Bin.new(bin_path.basename.to_s, bin_path.to_s)
        end
      end

      # Return true if all bins can execute and return version
      def all_bins_working?
        bins.all?(&:version)
      end

      # Return true if all bins can't execute and return version
      def all_bins_failing?
        bins.none?(&:version)
      end

      # List of bins which can execute and return version
      def working_bins
        bins.select(&:version)
      end

      # List of bins which can't execute and return version
      def failing_bins
        bins.reject(&:version)
      end

    private

      # All children except those starting with 'lib'
      def bin_paths
        path.children.reject{ |child| child.basename.to_s =~ /^lib/ }
      end
    end

    # downcased `uname -s`
    OS = begin
      `uname -s`.strip.downcase
    rescue Errno::ENOENT
      'unknown'
    end

    # downcased `uname -m`
    ARCH = begin
      `uname -m`.strip.downcase
    rescue Errno::ENOENT
      'unknown'
    end

    # Path to vendor at root of image_optim_pack
    VENDOR_PATH = FSPath('../../../vendor').expand_path(__FILE__)

    # List of paths
    PATHS = VENDOR_PATH.glob('*-*').map{ |path| Path.new(path) }

    class << self
      # Return path to directory with binaries
      # Yields debug messages if block given
      def path
        ordered_by_os_arch_match.find do |path|
          yield "image_optim_pack: #{debug_message(path)}" if block_given?
          path.all_bins_working?
        end
      end

    private

      # Order by match of os and architecture
      def ordered_by_os_arch_match
        PATHS.sort_by do |path|
          [path.os == OS ? 0 : 1, path.arch == ARCH ? 0 : 1]
        end
      end

      # Messages based on success of getting versions of bins
      def debug_message(path)
        case
        when path.all_bins_working?
          "all bins from #{path} worked"
        when path.all_bins_failing?
          "all bins from #{path} failed"
        else
          "#{path.failing_bins.map(&:name).join(', ')} from #{path} failed"
        end
      end
    end
  end
end
