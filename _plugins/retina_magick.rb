require 'mini_magick'

module Jekyll
  module JekyllRetinamagick

    class GeneratedImageFile < Jekyll::StaticFile
      # Initialize a new GeneratedImage.
      #   +site+ is the Site
      #   +base+ is the String path to the <source>
      #   +dir+ is the String path between <source> and the file
      #   +name+ is the String filename of the file
      #   +preset+ is the Preset hash from the config.
      #
      # Returns <GeneratedImageFile>
      def initialize(site, base, dir, name, preset, retina)
        @site = site
        @base = base
        @dir  = dir
        @name = name
        @dst_dir = preset.delete('destination')
        @src = File.join(@base, preset.delete('source'), name)
        @commands = preset
        if retina
          filepath, extension = name.match(/(.+)(\.[a-zA-Z]{3,4})/i).captures
          @name = "#{filepath}@2x#{extension}"
          if @commands.has_key?("resize")
            size = @commands["resize"]
            width, height = size.match(/([0-9]+)x([0-9]+)/i).captures
            @commands["resize"] = "#{Integer(width) * 2}x#{Integer(height) * 2}"
          end
        end
      end

      # Obtains source file path by substituting the preset's source directory
      # for the destination directory.
      #
      # Returns source file path.
      def path
        @src
      end

      # Use MiniMagick to create a derivative image at the destination
      # specified (if the original is modified).
      #   +dest+ is the String path to the destination dir
      #
      # Returns false if the file was not modified since last time (no-op).
      def write(dest)
        dest_path = destination(dest)

        return false if File.exist? dest_path

        @@mtimes[path] = mtime

        cache_path = File.join(@base, ".minimagick-cache", @dst_dir, @name)

        FileUtils.mkdir_p(File.dirname(cache_path))
        FileUtils.mkdir_p(File.dirname(dest_path))

        # If the file isn't cached, generate it
        if not (File.size? cache_path and File.stat(cache_path).mtime.to_i > mtime)
          image = ::MiniMagick::Image.open(path)
          @commands.each_pair do |command, arg|
            image.send command, arg
          end
          image.write cache_path
        end

        FileUtils.cp(cache_path, dest_path)
        
        true
      end

    end

    class MiniMagickGenerator < Generator
      safe true

      # Find all image files in the source directories of the presets specified
      # in the site config.  Add a GeneratedImageFile to the static_files stack
      # for later processing.
      def generate(site)
        return unless site.config['retinamagick']

        site.config['retinamagick'].each_pair do |name, preset|
          Dir.glob(File.join(site.source, preset['source'], "*.{png,jpg,jpeg,gif}")) do |source|
            site.static_files << GeneratedImageFile.new(site, site.source, preset['destination'], File.basename(source), preset.clone, false)
            if preset.has_key?("resize")
              site.static_files << GeneratedImageFile.new(site, site.source, preset['destination'], File.basename(source), preset.clone, true)
            end
          end
        end
      end
    end
  end
end
