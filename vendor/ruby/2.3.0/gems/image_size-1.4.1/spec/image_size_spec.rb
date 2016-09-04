$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rspec'
require 'image_size'

describe ImageSize do
  [
    ['test2.bmp', :bmp,  42,  50],
    ['test3b.bmp',:bmp,  42,  50],
    ['test3t.bmp',:bmp,  42,  50],
    ['test.gif',  :gif, 668, 481],
    ['test.jpg', :jpeg, 320, 240],
    ['test2.jpg',:jpeg, 320, 240],
    ['test.pbm',  :pbm,  85,  55],
    ['test.pcx',  :pcx,  70,  60],
    ['test.pgm',  :pgm,  90,  55],
    ['test.png',  :png, 640, 532],
    ['test.psd',  :psd,  16,  20],
    ['test.swf',  :swf, 450, 200],
    ['test.tif', :tiff,  48,  64],
    ['test.xbm',  :xbm,  16,  32],
    ['test.xpm',  :xpm,  24,  32],
    ['test.svg',  :svg,  72, 100],
    ['test.ico',  :ico, 256,  27],
    ['test.cur',  :cur,  50, 256],
    ['image_size_spec.rb', nil, nil, nil],
  ].each do |name, format, width, height|
    path = File.join(File.dirname(__FILE__), name)
    file_data = File.open(path, 'rb', &:read)

    it "should get format and dimensions for #{name} given IO" do
      File.open(path, 'rb') do |fh|
        is = ImageSize.new(fh)
        expect([is.format, is.width, is.height]).to eq([format, width, height])
        expect(fh).not_to be_closed
        fh.rewind
        expect(fh.read).to eq(file_data)
      end
    end

    it "should get format and dimensions for #{name} given StringIO" do
      io = StringIO.new(file_data)
      is = ImageSize.new(io)
      expect([is.format, is.width, is.height]).to eq([format, width, height])
      expect(io).not_to be_closed
      io.rewind
      expect(io.read).to eq(file_data)
    end

    it "should get format and dimensions for #{name} given file data" do
      is = ImageSize.new(file_data)
      expect([is.format, is.width, is.height]).to eq([format, width, height])
    end

    it "should get format and dimensions for #{name} given Tempfile" do
      Tempfile.open(name) do |tf|
        tf.binmode
        tf.write(file_data)
        tf.rewind
        is = ImageSize.new(tf)
        expect([is.format, is.width, is.height]).to eq([format, width, height])
        expect(tf).not_to be_closed
        tf.rewind
        expect(tf.read).to eq(file_data)
      end
    end

    it "should get format and dimensions for #{name} given IO when run twice" do
      File.open(path, 'rb') do |fh|
        is = ImageSize.new(fh)
        expect([is.format, is.width, is.height]).to eq([format, width, height])
        is = ImageSize.new(fh)
        expect([is.format, is.width, is.height]).to eq([format, width, height])
      end
    end

    it "should get format and dimensions for #{name} as path" do
      is = ImageSize.path(path)
      expect([is.format, is.width, is.height]).to eq([format, width, height])
    end
  end

  it "should raise ArgumentError if argument is not valid" do
    expect {
      ImageSize.new(Object)
    }.to raise_error(ArgumentError)
  end

  {
    :png => "\211PNG\r\n\032\n",
    :jpeg => "\377\330",
  }.each do |type, data|
    it "should raise FormatError if invalid #{type} given" do
      expect {
        ImageSize.new(data)
      }.to raise_error(ImageSize::FormatError)
    end
  end
end
