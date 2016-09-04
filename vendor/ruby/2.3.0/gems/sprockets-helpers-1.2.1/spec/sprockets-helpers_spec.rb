require 'spec_helper'

describe Sprockets::Helpers do
  describe '.configure' do
    it 'sets global configuration' do
      within_construct do |c|
        c.file 'assets/main.css'

        expect(context.asset_path('main.css')).to eq('/assets/main.css')

        Sprockets::Helpers.configure do |config|
          config.digest = true
          config.prefix = '/themes'
        end

        expect(context.asset_path('main.css')).to match(%r(/themes/main-[0-9a-f]+.css))
        Sprockets::Helpers.digest = nil
        Sprockets::Helpers.prefix = nil
      end
    end
  end

  describe '.digest' do
    it 'globally configures digest paths' do
      within_construct do |c|
        c.file 'assets/main.js'

        expect(context.asset_path('main', :ext => 'js')).to eq('/assets/main.js')
        Sprockets::Helpers.digest = true
        expect(context.asset_path('main', :ext => 'js')).to match(%r(/assets/main-[0-9a-f]+.js))
        Sprockets::Helpers.digest = nil
      end
    end
  end

  describe '.environment' do
    it 'sets a custom assets environment' do
      within_construct do |c|
        c.file 'themes/main.css'

        custom_env = Sprockets::Environment.new
        custom_env.append_path 'themes'
        Sprockets::Helpers.environment = custom_env
        expect(context.asset_path('main.css')).to eq('/assets/main.css')
        Sprockets::Helpers.environment = nil
      end
    end
  end

  describe '.asset_host' do
    context 'that is a string' do
      it 'prepends the asset_host' do
        within_construct do |c|
          c.file 'assets/main.js'
          c.file 'public/logo.jpg'

          Sprockets::Helpers.asset_host = 'assets.example.com'
          expect(context.asset_path('main.js')).to eq('http://assets.example.com/assets/main.js')
          expect(context.asset_path('logo.jpg')).to match(%r(http://assets.example.com/logo.jpg\?\d+))
          Sprockets::Helpers.asset_host = nil
        end
      end

      context 'with a wildcard' do
        it 'cycles asset_host between 0-3' do
          within_construct do |c|
            c.file 'assets/main.css'
            c.file 'public/logo.jpg'

            Sprockets::Helpers.asset_host = 'assets%d.example.com'
            expect(context.asset_path('main.css')).to match(%r(http://assets[0-3].example.com/assets/main.css))
            expect(context.asset_path('logo.jpg')).to match(%r(http://assets[0-3].example.com/logo.jpg\?\d+))
            Sprockets::Helpers.asset_host = nil
          end
        end
      end
    end

    context 'that is a proc' do
      it 'prepends the returned asset_host' do
        within_construct do |c|
          c.file 'assets/main.js'
          c.file 'public/logo.jpg'

          Sprockets::Helpers.asset_host = Proc.new { |source| File.basename(source, File.extname(source)) + '.assets.example.com' }
          expect(context.asset_path('main.js')).to eq('http://main.assets.example.com/assets/main.js')
          expect(context.asset_path('logo.jpg')).to match(%r(http://logo.assets.example.com/logo.jpg\?\d+))
          Sprockets::Helpers.asset_host = nil
        end
      end
    end
  end

  describe '.prefix' do
    it 'sets a custom assets prefix' do
      within_construct do |c|
        c.file 'assets/logo.jpg'

        expect(context.asset_path('logo.jpg')).to eq('/assets/logo.jpg')
        Sprockets::Helpers.prefix = '/images'
        expect(context.asset_path('logo.jpg')).to eq('/images/logo.jpg')
        Sprockets::Helpers.prefix = nil
      end
    end
  end

  describe '.protocol' do
    it 'sets the protocol to use with asset_hosts' do
      within_construct do |c|
        c.file 'assets/main.js'
        c.file 'public/logo.jpg'

        Sprockets::Helpers.asset_host = 'assets.example.com'
        Sprockets::Helpers.protocol   = 'https'
        expect(context.asset_path('main.js')).to eq('https://assets.example.com/assets/main.js')
        expect(context.asset_path('logo.jpg')).to match(%r(https://assets.example.com/logo.jpg\?\d+))
        Sprockets::Helpers.asset_host = nil
        Sprockets::Helpers.protocol   = nil
      end
    end

    context 'that is :relative' do
      it 'sets a relative protocol' do
        within_construct do |c|
          c.file 'assets/main.js'
          c.file 'public/logo.jpg'

          Sprockets::Helpers.asset_host = 'assets.example.com'
          Sprockets::Helpers.protocol   = :relative
          expect(context.asset_path('main.js')).to eq('//assets.example.com/assets/main.js')
          expect(context.asset_path('logo.jpg')).to match(%r(\A//assets.example.com/logo.jpg\?\d+))
          Sprockets::Helpers.asset_host = nil
          Sprockets::Helpers.protocol   = nil
        end
      end
    end
  end

  describe '.public_path' do
    it 'sets a custom location for the public path' do
      within_construct do |c|
        c.file 'output/main.js'

        expect(context.asset_path('main.js')).to eq('/main.js')
        Sprockets::Helpers.public_path = './output'
        expect(context.asset_path('main.js')).to match(%r(/main.js\?\d+))
        Sprockets::Helpers.public_path = nil
      end
    end
  end

  describe '#asset_path' do
    context 'with URIs' do
      it 'returns URIs untouched' do
        expect(context.asset_path('https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js')).to eq('https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js')
        expect(context.asset_path('http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js')).to eq('http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js')
        expect(context.asset_path('//ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js')).to eq('//ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js')
      end
    end

    context 'with regular files' do
      it 'returns absolute paths' do
        expect(context.asset_path('/path/to/file.js')).to eq('/path/to/file.js')
        expect(context.asset_path('/path/to/file.jpg')).to eq('/path/to/file.jpg')
        expect(context.asset_path('/path/to/file.eot?#iefix')).to eq('/path/to/file.eot?#iefix')
      end

      it 'appends the extension for javascripts and stylesheets' do
        expect(context.asset_path('/path/to/file', :ext => 'js')).to eq('/path/to/file.js')
        expect(context.asset_path('/path/to/file', :ext => 'css')).to eq('/path/to/file.css')
      end

      it 'prepends a base dir' do
        expect(context.asset_path('main', :dir => 'stylesheets', :ext => 'css')).to eq('/stylesheets/main.css')
        expect(context.asset_path('main', :dir => 'javascripts', :ext => 'js')).to eq('/javascripts/main.js')
        expect(context.asset_path('logo.jpg', :dir => 'images')).to eq('/images/logo.jpg')
      end

      it 'appends a timestamp if the file exists in the output path' do
        within_construct do |c|
          c.file 'public/main.js'
          c.file 'public/favicon.ico'
          c.file 'public/font.eot'
          c.file 'public/font.svg'

          expect(context.asset_path('main', :ext => 'js')).to match(%r{/main.js\?\d+})
          expect(context.asset_path('/favicon.ico')).to match(%r{/favicon.ico\?\d+})
          expect(context.asset_path('font.eot?#iefix')).to match(%r{/font.eot\?\d+#iefix})
          expect(context.asset_path('font.svg#FontName')).to match(%r{/font.svg\?\d+#FontName})
        end
      end
    end

    context 'with assets' do
      it 'returns URLs to the assets' do
        within_construct do |c|
          c.file 'assets/logo.jpg'
          c.file 'assets/main.js'
          c.file 'assets/main.css'

          expect(context.asset_path('main', :ext => 'css')).to eq('/assets/main.css')
          expect(context.asset_path('main', :ext => 'js')).to eq('/assets/main.js')
          expect(context.asset_path('logo.jpg')).to eq('/assets/logo.jpg')
        end
      end

      it 'prepends the assets prefix' do
        within_construct do |c|
          c.file 'assets/logo.jpg'

          expect(context.asset_path('logo.jpg')).to eq('/assets/logo.jpg')
          expect(context.asset_path('logo.jpg', :prefix => '/images')).to eq('/images/logo.jpg')
        end
      end

      it 'uses the digest path if configured' do
        within_construct do |c|
          c.file 'assets/main.js'
          c.file 'assets/font.eot'
          c.file 'assets/font.svg'

          expect(context.asset_path('main', :ext => 'js')).to eq('/assets/main.js')
          expect(context.asset_path('main', :ext => 'js', :digest => true)).to match(%r{/assets/main-[0-9a-f]+.js})
          expect(context.asset_path('font.eot?#iefix', :digest => true)).to match(%r{/assets/font-[0-9a-f]+.eot\?#iefix})
          expect(context.asset_path('font.svg#FontName', :digest => true)).to match(%r{/assets/font-[0-9a-f]+.svg#FontName})
        end
      end

      it 'returns a body parameter' do
        within_construct do |c|
          c.file 'assets/main.js'
          c.file 'assets/font.eot'
          c.file 'assets/font.svg'

          expect(context.asset_path('main', :ext => 'js', :body => true)).to eq('/assets/main.js?body=1')
          expect(context.asset_path('font.eot?#iefix', :body => true)).to eq('/assets/font.eot?body=1#iefix')
          expect(context.asset_path('font.svg#FontName', :body => true)).to eq('/assets/font.svg?body=1#FontName')
        end
      end
    end

    context 'when debuging' do
      it 'does not use the digest path' do
        within_construct do |c|
          c.file 'assets/main.js'

          Sprockets::Helpers.digest = true
          expect(context.asset_path('main.js', :debug => true)).to eq('/assets/main.js')
          Sprockets::Helpers.digest = nil
        end
      end

      it 'does not prepend the asset host' do
        within_construct do |c|
          c.file 'assets/main.js'

          Sprockets::Helpers.asset_host = 'assets.example.com'
          expect(context.asset_path('main.js', :debug => true)).to eq('/assets/main.js')
          Sprockets::Helpers.asset_host = nil
        end
      end
    end

    if defined?(::Sprockets::Manifest)
      context 'with a manifest' do
        it 'reads path from a manifest file' do
          within_construct do |c|
            asset_file    = c.file 'assets/application.js'
            manifest_file = c.join 'manifest.json'

            manifest = Sprockets::Manifest.new(env, manifest_file)
            manifest.compile 'application.js'

            Sprockets::Helpers.configure do |config|
              config.digest   = true
              config.prefix   = '/assets'
              config.manifest = Sprockets::Manifest.new(env, manifest_file)
            end

            asset_file.delete
            expect(context.asset_path('application.js')).to match(%r(/assets/application-[0-9a-f]+.js))

            Sprockets::Helpers.digest = nil
            Sprockets::Helpers.prefix = nil
          end
        end

        context 'when debuging' do
          context 'when set individually' do
            it 'does not read the path from the manifest file' do
              within_construct do |c|
                asset_file    = c.file 'assets/application.js'
                manifest_file = c.join 'manifest.json'

                manifest = Sprockets::Manifest.new(env, manifest_file)
                manifest.compile 'application.js'

                Sprockets::Helpers.configure do |config|
                  config.digest   = true
                  config.prefix   = '/assets'
                  config.manifest = Sprockets::Manifest.new(env, manifest_file)
                end

                expect(context.asset_path('application.js', :debug => true)).to eq('/assets/application.js')

                Sprockets::Helpers.digest = nil
                Sprockets::Helpers.prefix = nil
              end
            end
          end

          context 'when set globally' do
            it 'does not read the path from the manifest file' do
              within_construct do |c|
                asset_file    = c.file 'assets/application.js'
                manifest_file = c.join 'manifest.json'

                manifest = Sprockets::Manifest.new(env, manifest_file)
                manifest.compile 'application.js'

                Sprockets::Helpers.debug = true
                Sprockets::Helpers.configure do |config|
                  config.prefix   = '/assets'
                  config.manifest = Sprockets::Manifest.new(env, manifest_file)
                end

                expect(context.asset_path('application.js')).to eq('/assets/application.js')

                Sprockets::Helpers.debug = nil
                Sprockets::Helpers.prefix = nil
              end
            end
          end
        end
      end
    end
  end

  describe '#javascript_path' do
    context 'with regular files' do
      it 'appends the js extension' do
        expect(context.javascript_path('/path/to/file')).to eq('/path/to/file.js')
        expect(context.javascript_path('/path/to/file.min')).to eq('/path/to/file.min.js')
      end

      it 'prepends the javascripts dir' do
        expect(context.javascript_path('main')).to eq('/javascripts/main.js')
        expect(context.javascript_path('main.min')).to eq('/javascripts/main.min.js')
      end
    end
  end

  describe '#stylesheet_path' do
    context 'with regular files' do
      it 'appends the css extension' do
        expect(context.stylesheet_path('/path/to/file')).to eq('/path/to/file.css')
        expect(context.stylesheet_path('/path/to/file.min')).to eq('/path/to/file.min.css')
      end

      it 'prepends the stylesheets dir' do
        expect(context.stylesheet_path('main')).to eq('/stylesheets/main.css')
        expect(context.stylesheet_path('main.min')).to eq('/stylesheets/main.min.css')
      end
    end
  end

  describe '#image_path' do
    context 'with regular files' do
      it 'prepends the images dir' do
        expect(context.image_path('logo.jpg')).to eq('/images/logo.jpg')
      end
    end
  end

  describe '#font_path' do
    context 'with regular files' do
      it 'prepends the fonts dir' do
        expect(context.font_path('font.ttf')).to eq('/fonts/font.ttf')
      end
    end
  end

  describe '#video_path' do
    context 'with regular files' do
      it 'prepends the videos dir' do
        expect(context.video_path('video.mp4')).to eq('/videos/video.mp4')
      end
    end
  end

  describe '#audio_path' do
    context 'with regular files' do
      it 'prepends the audios dir' do
        expect(context.audio_path('audio.mp3')).to eq('/audios/audio.mp3')
      end
    end
  end

  describe '#asset_tag' do
    after do
      Sprockets::Helpers.debug = nil
      Sprockets::Helpers.expand = nil
    end

    it 'receives block to generate tag' do
      actual = context.asset_tag('main.js') { |path| "<script src=#{path}></script>" }
      expect(actual).to eq('<script src=/main.js></script>')
    end

    it 'raises when called without block' do
      expect { context.asset_tag('main.js') }.to raise_error(ArgumentError, 'block missing')
    end

    it 'expands when configured' do
      within_construct do |construct|
        assets_layout(construct)
        Sprockets::Helpers.expand = true
        c = context
        allow(c).to(
          receive(:asset_path)
          .and_return(context.asset_path('main.js'))
        ) # Spy
        expect(c).to(
          receive(:asset_path)
          .with('main.js', {:expand => true, :debug => nil})
        )
        c.asset_tag('main.js') {}
        Sprockets::Helpers.expand = false
        expect(c).to(
          receive(:asset_path)
          .with('main.js', {:expand => false, :debug => nil})
        )
        c.asset_tag('main.js') {}
      end
    end

    it 'force to be debug mode when globally configured' do
      within_construct do |construct|
        assets_layout(construct)
        Sprockets::Helpers.debug = true
        c = context
        allow(c).to(
          receive(:asset_path)
          .and_return(context.asset_path('main.js'))
        ) # Spy
        expect(c).to(
          receive(:asset_path)
          .with('main.js', {:expand => true, :debug => true})
        )
        c.asset_tag('main.js') {}
        Sprockets::Helpers.debug = false
        expect(c).to(
          receive(:asset_path)
          .with('main.js', {:expand => false, :debug => false})
        )
        c.asset_tag('main.js') {}
      end
    end

    describe 'when expanding' do
      it 'passes uri that is no asset untouched' do
        context.asset_tag('main.js', :expand => true) {}
      end

      context "in Sprockets 2.x" do
        next if Sprockets::Helpers.are_using_sprockets_3
        it 'generates tag for each asset' do
          within_construct do |construct|
            assets_layout(construct)
            tags = context.asset_tag('main.js', :expand => true) do |path|
              "<script src=\"#{path}\"></script>"
            end
            expect(tags.split('</script>').size).to eq(3)
            expect(tags).to include('<script src="/assets/main.js?body=1"></script>')
            expect(tags).to include('<script src="/assets/a.js?body=1"></script>')
            expect(tags).to include('<script src="/assets/b.js?body=1"></script>')
          end
        end
      end

      context "in Sprockets 3.x" do
        next unless Sprockets::Helpers.are_using_sprockets_3
        it 'generates tag for each asset' do
          within_construct do |construct|
            assets_layout(construct)
            tags = context.asset_tag('main.js', :expand => true) do |path|
              "<script src=\"#{path}\"></script>"
            end
            expect(tags.split('</script>').size).to eq(3)
            expect(tags).to include('<script src="/assets/main.self.js?body=1"></script>')
            expect(tags).to include('<script src="/assets/a.self.js?body=1"></script>')
            expect(tags).to include('<script src="/assets/b.self.js?body=1"></script>')
          end
        end
      end
    end

    if defined?(Sprockets::Manifest)
      describe 'when globally debug mode is set' do
        it 'generates tag for each asset without reading the path from manifest file' do
          within_construct do |construct|
            assets_layout(construct)
            manifest_file = construct.join 'manifest.json'

            manifest = Sprockets::Manifest.new(env, manifest_file)
            manifest.compile 'main.js'
            Sprockets::Helpers.debug = true
            Sprockets::Helpers.configure do |config|
              config.prefix   = '/assets'
              config.manifest = Sprockets::Manifest.new(env, manifest_file)
            end

            tags = context.asset_tag('main.js') do |path|
              "<script src=\"#{path}\"></script>"
            end
            expect(tags.split('</script>').size).to eq(3)

            if Sprockets::Helpers.are_using_sprockets_3
              expect(tags).to include('<script src="/assets/main.self.js?body=1"></script>')
              expect(tags).to include('<script src="/assets/a.self.js?body=1"></script>')
              expect(tags).to include('<script src="/assets/b.self.js?body=1"></script>')
            else
              expect(tags).to include('<script src="/assets/main.js?body=1"></script>')
              expect(tags).to include('<script src="/assets/a.js?body=1"></script>')
              expect(tags).to include('<script src="/assets/b.js?body=1"></script>')
            end

            Sprockets::Helpers.debug = false
            Sprockets::Helpers.prefix = nil
            Sprockets::Helpers.manifest = nil
          end
        end
      end
    end
  end

  describe '#javascript_tag' do
    it 'generates script tag' do
      expect(context.javascript_tag('/main.js')).to eq('<script src="/main.js"></script>')
    end

    it 'appends extension' do
      expect(context.javascript_tag('/main')).to eq('<script src="/main.js"></script>')
    end

    it 'prepends the javascript dir' do
      expect(context.javascript_tag('main')).to eq('<script src="/javascripts/main.js"></script>')
    end

    describe 'when expanding' do
      context 'in Sprockets 3.x' do
        next unless Sprockets::Helpers.are_using_sprockets_3
        it 'generates script tag for each javascript asset' do
          within_construct do |construct|
            assets_layout(construct)
            tags = context.javascript_tag('main.js', :expand => true)
            expect(tags).to include('<script src="/assets/main.self.js?body=1"></script>')
            expect(tags).to include('<script src="/assets/a.self.js?body=1"></script>')
            expect(tags).to include('<script src="/assets/b.self.js?body=1"></script>')
          end
        end
      end

      context 'in Sprockets 2.x' do
        next if Sprockets::Helpers.are_using_sprockets_3
        it 'generates script tag for each javascript asset' do
          within_construct do |construct|
            assets_layout(construct)
            tags = context.javascript_tag('main.js', :expand => true)

            expect(tags).to include('<script src="/assets/main.js?body=1"></script>')
            expect(tags).to include('<script src="/assets/a.js?body=1"></script>')
            expect(tags).to include('<script src="/assets/b.js?body=1"></script>')
          end
        end
      end
    end
  end

  describe '#stylesheet_tag' do
    it 'generates stylesheet tag' do
      expect(context.stylesheet_tag('/main.css')).to eq('<link rel="stylesheet" href="/main.css">')
    end

    it 'appends extension' do
      expect(context.stylesheet_tag('/main')).to eq('<link rel="stylesheet" href="/main.css">')
    end

    it 'prepends the stylesheets dir' do
      expect(context.stylesheet_tag('main')).to eq('<link rel="stylesheet" href="/stylesheets/main.css">')
    end

    it 'uses media attribute when provided' do
      expect(context.stylesheet_tag('main', :media => "print")).to eq('<link rel="stylesheet" href="/stylesheets/main.css" media="print">')
    end

    describe 'when expanding' do
      context 'in Sprockets 3.x' do
        it 'generates stylesheet tag for each stylesheet asset' do
          next unless Sprockets::Helpers.are_using_sprockets_3
          within_construct do |construct|
            assets_layout(construct)
            tags = context.stylesheet_tag('main.css', :expand => true)
            expect(tags).to include('<link rel="stylesheet" href="/assets/main.self.css?body=1">')
            expect(tags).to include('<link rel="stylesheet" href="/assets/a.self.css?body=1">')
            expect(tags).to include('<link rel="stylesheet" href="/assets/b.self.css?body=1">')
          end
        end
      end

      context "in Sprockets 2.x" do
        next if Sprockets::Helpers.are_using_sprockets_3
        it 'generates stylesheet tag for each stylesheet asset' do
          within_construct do |construct|
            assets_layout(construct)
            tags = context.stylesheet_tag('main.css', :expand => true)
            expect(tags).to include('<link rel="stylesheet" href="/assets/main.css?body=1">')
            expect(tags).to include('<link rel="stylesheet" href="/assets/a.css?body=1">')
            expect(tags).to include('<link rel="stylesheet" href="/assets/b.css?body=1">')
          end
        end
      end
    end
  end

  describe 'Sinatra integration' do
    after do
      ::Sprockets::Helpers.environment = nil
      ::Sprockets::Helpers.public_path = nil
      ::Sprockets::Helpers.digest = nil
      ::Sprockets::Helpers.prefix = nil
      ::Sprockets::Helpers.expand = nil
    end

    it 'adds the helpers' do
      app = Class.new(Sinatra::Base) do
        register Sinatra::Sprockets::Helpers
      end

      expect(app).to include(Sprockets::Helpers)
    end

    it 'automatically configures' do
      custom_env = Sprockets::Environment.new

      app = Class.new(Sinatra::Base) do
        set :sprockets, custom_env
        set :assets_prefix, '/static'
        set :digest_assets, true

        register Sinatra::Sprockets::Helpers
      end

      expect(Sprockets::Helpers.environment).to be(custom_env)
      expect(Sprockets::Helpers.prefix).to eq('/static')
      expect(Sprockets::Helpers.digest).to be_truthy
    end

    it 'uses first prefix if assets_prefix is an array' do
      custom_env = Sprockets::Environment.new

      app = Class.new(Sinatra::Base) do
        set :sprockets, custom_env
        set :assets_prefix,  %w(assets vendor/assets)

        register Sinatra::Sprockets::Helpers
      end

      expect(Sprockets::Helpers.environment).to be(custom_env)
      expect(Sprockets::Helpers.prefix).to eq('/assets')
    end

    it 'manually configures with configure method' do
      custom_env = Sprockets::Environment.new

      app = Class.new(Sinatra::Base) do
        register Sinatra::Sprockets::Helpers

        set :sprockets, custom_env
        set :assets_prefix, '/static'

        configure_sprockets_helpers do |helpers|
          helpers.expand = true
        end
      end

      expect(Sprockets::Helpers.environment).to be(custom_env)
      expect(Sprockets::Helpers.prefix).to eq('/static')
      expect(Sprockets::Helpers.expand).to be_truthy
    end
  end
end
