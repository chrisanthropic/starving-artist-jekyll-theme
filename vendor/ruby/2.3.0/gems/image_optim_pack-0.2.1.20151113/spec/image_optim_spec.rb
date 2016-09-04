require 'spec_helper'
require 'image_optim'
require 'image_optim/cmd'
require 'tempfile'
require 'English'

describe ImageOptim do
  def self.temp_copy(image)
    image.temp_path.tap{ |path| image.copy(path) }
  end

  before do
    stub_const('Cmd', ImageOptim::Cmd)
  end

  def flatten_animation(image)
    if image.format == :gif
      flattened = image.temp_path
      flatten_command = %W[
        convert
        #{image.to_s.shellescape}
        -coalesce
        -append
        #{flattened.to_s.shellescape}
      ].join(' ')
      expect(Cmd.run(flatten_command)).to be_truthy
      flattened
    else
      image
    end
  end

  def nrmse(image_a, image_b)
    coalesce_a = flatten_animation(image_a)
    coalesce_b = flatten_animation(image_b)
    nrmse_command = %W[
      compare
      -metric RMSE
      -alpha Background
      #{coalesce_a.to_s.shellescape}
      #{coalesce_b.to_s.shellescape}
      /dev/null
      2>&1
    ].join(' ')
    output = Cmd.capture(nrmse_command)
    if [0, 1].include?($CHILD_STATUS.exitstatus)
      output[/\((\d+(\.\d+)?)\)/, 1].to_f
    else
      fail "compare #{image_a} with #{image_b} failed with `#{output}`"
    end
  end

  define :have_same_data_as do |expected|
    match{ |actual| actual.binread == expected.binread }
  end

  define :have_size do
    match(&:size?)
  end

  define :be_smaller_than do |expected|
    match{ |actual| actual.size < expected.size }
  end

  define :be_pixel_identical_to do |expected|
    match do |actual|
      @diff = nrmse(actual, expected)
      @diff == 0
    end
    failure_message do |actual|
      "expected #{actual} to be pixel identical to #{expected}, got "\
          "normalized root-mean-square error of #{@diff}"
    end
  end

  image_optim = ImageOptim.new

  # grab images from image_optim gem
  image_optim_root = Gem.loaded_specs['image_optim'].gem_dir
  images_dir = ImageOptim::ImagePath.new(image_optim_root) / 'spec/images'
  test_images = images_dir.glob('**/*.*')

  # select images which for which there are workers
  test_images = test_images.select do |image|
    image_optim.workers_for_image(image)
  end

  rotated = images_dir / 'orient/original.jpg'
  rotate_images = images_dir.glob('orient/?.jpg')

  copies = test_images.map{ |image| temp_copy(image) }
  original_by_copy = Hash[copies.zip(test_images)]

  image_optim.optimize_images(copies) do |copy, optimized|
    fail 'expected copy to not be nil' if copy.nil?
    original = original_by_copy[copy]

    it "optimizes #{original}" do
      expect(copy).to have_same_data_as(original)

      expect(optimized).not_to be_nil
      expect(optimized).to have_size
      expect(optimized).to be_smaller_than(original)
      expect(optimized).not_to have_same_data_as(original)

      compare_to = rotate_images.include?(original) ? rotated : original
      expect(optimized).to be_pixel_identical_to(compare_to)
    end
  end
end
