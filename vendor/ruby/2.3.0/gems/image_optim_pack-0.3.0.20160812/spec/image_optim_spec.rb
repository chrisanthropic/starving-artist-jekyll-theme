require 'spec_helper'
require 'image_optim'
require 'image_optim/cmd'
require 'tempfile'
require 'English'

describe ImageOptim do
  before do
    stub_const('Cmd', ImageOptim::Cmd)
  end

  # grab images from image_optim gem
  image_optim_root = Gem.loaded_specs['image_optim'].gem_dir
  images_dir = FSPath.new(image_optim_root) / 'spec/images'
  test_images = images_dir.glob('**/*.*')

  isolated_options_base = {:skip_missing_workers => false}
  ImageOptim::Worker.klasses.each do |klass|
    isolated_options_base[klass.bin_sym] = false
  end

  ImageOptim::Worker.klasses.each do |worker_klass|
    next if [:pngout, :svgo].include?(worker_klass.bin_sym)

    describe "#{worker_klass.bin_sym} worker" do
      it 'optimizes at least one test image' do
        options = isolated_options_base.merge(worker_klass.bin_sym => true)

        image_optim = ImageOptim.new(options)
        if Array(worker_klass.init(image_optim)).empty?
          image_optim = ImageOptim.new(options.merge(:allow_lossy => true))
        end

        expect(test_images.any? do |original|
          image_optim.optimize_image(original)
        end).to be true
      end
    end
  end
end
