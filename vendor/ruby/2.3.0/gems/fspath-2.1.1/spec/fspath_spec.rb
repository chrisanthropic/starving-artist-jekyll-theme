require 'fspath'

describe FSPath do
  class ZPath < FSPath
  end

  it 'inherits from Pathname' do
    expect(FSPath.new('.')).to be_kind_of(Pathname)
  end

  it 'uses shortcut' do
    expect(FSPath('.')).to eql(FSPath.new('.'))
  end

  describe '~' do
    it 'returns current user home directory' do
      expect(FSPath.~).to eq(FSPath(File.expand_path('~')))
    end

    it 'returns other user home directory' do
      expect(FSPath.~('root')).to eq(FSPath(File.expand_path('~root')))
    end
  end

  describe 'common_dir' do
    it 'returns dirname if called with one path' do
      expect(FSPath.common_dir('/a/b/c')).to eq(FSPath('/a/b'))
    end

    it 'returns common path if called with mulpitle paths' do
      expect(FSPath.common_dir('/a/b/c/d/e', '/a/b/c/d/f', '/a/b/c/z')).
        to eq(FSPath('/a/b/c'))
    end

    it 'returns nil if there is no common path' do
      expect(FSPath.common_dir('../a', './b')).to be_nil
    end
  end

  [FSPath, ZPath].each do |klass|
    describe "#{klass}.temp_file" do
      it "returns Tempfile with path returning instance of #{klass}" do
        expect(klass.temp_file).to be_kind_of(Tempfile)
        expect(klass.temp_file.path).to be_kind_of(klass)
      end

      it "yields Tempfile with path returning instance of #{klass}" do
        yielded = nil
        klass.temp_file{ |y| yielded = y }
        expect(yielded).to be_kind_of(Tempfile)
        expect(yielded.path).to be_kind_of(klass)
      end

      it 'returns result of block' do
        expect(klass.temp_file{ :result }).to eq(:result)
      end

      it 'calls appropriate initializer (jruby 1.8 mode bug)' do
        expect do
          klass.temp_file('abc', '.'){}
        end.not_to raise_error
      end
    end

    describe "#{klass}.temp_file_path" do
      it "returns #{klass} with temporary path" do
        expect(klass.temp_file_path).to be_kind_of(klass)
      end

      it 'does not allow GC to finalize TempFile' do
        paths = Array.new(1000){ FSPath.temp_file_path }
        expect(paths).to be_all(&:exist?)
        GC.start
        expect(paths).to be_all(&:exist?)
      end

      it "yields #{klass} with temporary path" do
        yielded = nil
        klass.temp_file_path{ |y| yielded = y }
        expect(yielded).to be_kind_of(klass)
      end
    end
  end

  describe 'temp_dir' do
    it 'returns result of running Dir.mktmpdir as FSPath instance' do
      @path = '/tmp/a/b/1'
      allow(Dir).to receive(:mktmpdir).and_return(@path)

      expect(FSPath.temp_dir).to eq(FSPath('/tmp/a/b/1'))
    end

    it 'yields path yielded by Dir.mktmpdir as FSPath instance' do
      @path = '/tmp/a/b/2'
      allow(Dir).to receive(:mktmpdir).and_yield(@path)

      yielded = nil
      FSPath.temp_dir{ |y| yielded = y }
      expect(yielded).to eq(FSPath('/tmp/a/b/2'))
    end
  end

  describe '/' do
    it 'joins path with string' do
      expect(FSPath('a') / 'b').to eq(FSPath('a/b'))
    end

    it 'joins path with another FSPath' do
      expect(FSPath('a') / FSPath('b')).to eq(FSPath('a/b'))
    end

    it 'joins with path starting with slash' do
      expect(FSPath('a') / '/b').to eq(FSPath('a/b'))
    end
  end

  describe '+' do
    it 'returns instance of FSPath' do
      expect(FSPath('a') + 'b').to be_instance_of(FSPath)
    end

    it 'joins simple paths' do
      expect(FSPath('a') + 'b').to eq(FSPath('a/b'))
    end

    it 'joins path starting with slash' do
      expect(FSPath('a') + '/b').to eq(FSPath('/b'))
    end
  end

  describe 'relative_path_from' do
    it 'returns instance of FSPath' do
      expect(FSPath('a').relative_path_from('b')).to be_instance_of(FSPath)
    end

    it 'returns relative path' do
      expect(FSPath('b/a').relative_path_from('b')).to eq(FSPath('a'))
    end
  end

  describe 'writing' do
    before do
      @path = FSPath.new('test')
      @file = double(:file)
      @data = double(:data)
      @size = double(:size)

      allow(@path).to receive(:open).and_yield(@file)
      allow(@file).to receive(:write).and_return(@size)
    end

    describe 'write' do
      it 'opens file for writing' do
        expect(@path).to receive(:open).with('wb')
        @path.write(@data)
      end

      it 'writes data' do
        expect(@file).to receive(:write).with(@data)
        @path.write(@data)
      end

      it 'returns result of write' do
        expect(@path.write(@data)).to eq(@size)
      end
    end

    describe 'append' do
      it 'opens file for writing' do
        expect(@path).to receive(:open).with('ab')
        @path.append(@data)
      end

      it 'writes data' do
        expect(@file).to receive(:write).with(@data)
        @path.append(@data)
      end

      it 'returns result of write' do
        expect(@path.append(@data)).to eq(@size)
      end
    end
  end

  describe 'escape_glob' do
    it 'escapes glob pattern characters' do
      expect(FSPath('*/**/?[a-z]{abc,def}').escape_glob).
        to eq(FSPath('\*/\*\*/\?\[a-z\]\{abc,def\}'))
    end
  end

  describe 'glob' do
    it 'joins with arguments and expands glob' do
      expect(FSPath).to receive(:glob).with('a/b/c/**/*')
      FSPath('a/b/c').glob('**', '*')
    end

    it 'joins with arguments and expands glob' do
      @flags = 12_345
      expect(FSPath).to receive(:glob).with('a/b/c/**/*', @flags)
      FSPath('a/b/c').glob('**', '*', @flags)
    end

    it 'escapes glob characters in path itself' do
      expect(FSPath).to receive(:glob).with('somewhere \[a b c\]/**/*')
      FSPath('somewhere [a b c]').glob('**', '*')
    end
  end

  describe 'path parts' do
    describe 'ascending' do
      before do
        @path = FSPath('/a/b/c')
        @ascendants = %w[/a/b/c /a/b /a /].map(&method(:FSPath))
      end

      describe 'ascendants' do
        it 'returns list of ascendants' do
          expect(@path.ascendants).to eq(@ascendants)
        end
      end

      describe 'ascend' do
        it 'returns list of ascendants' do
          expect(@path.ascend).to eq(@ascendants)
        end

        it 'yields and returns list of ascendants if called with block' do
          ascendants = []
          expect(@path.ascend do |path|
            ascendants << path
          end).to eq(@ascendants)
          expect(ascendants).to eq(@ascendants)
        end
      end
    end

    describe 'descending' do
      before do
        @path = FSPath('/a/b/c')
        @descendants = %w[/ /a /a/b /a/b/c].map(&method(:FSPath))
      end

      describe 'descendants' do
        it 'returns list of descendants' do
          expect(@path.descendants).to eq(@descendants)
        end
      end

      describe 'descend' do
        it 'returns list of descendants' do
          expect(@path.descend).to eq(@descendants)
        end

        it 'yields and returns list of descendants if called with block' do
          descendants = []
          expect(@path.descend do |path|
            descendants << path
          end).to eq(@descendants)
          expect(descendants).to eq(@descendants)
        end
      end
    end

    describe 'parts' do
      it 'returns path parts as strings' do
        expect(FSPath('/a/b/c').parts).to eq(%w[/ a b c])
      end
    end
  end

  describe 'returning/yielding instances' do
    def fspath?(path)
      expect(path).to be_instance_of(FSPath)
    end

    def fspaths?(paths)
      paths.each do |path|
        fspath? path
      end
    end

    it 'uses FSPath for glob' do
      fspaths? FSPath(__FILE__).glob

      FSPath(__FILE__).glob do |path|
        fspath? path
      end
    end

    it 'uses FSPath for pwd' do
      fspath? FSPath.pwd
    end

    it 'uses FSPath for getwd' do
      fspath? FSPath.getwd
    end

    it 'uses FSPath for basename' do
      fspath? FSPath('a/b').basename
    end

    it 'uses FSPath for dirname' do
      fspath? FSPath('a/b').dirname
    end

    it 'uses FSPath for parent' do
      fspath? FSPath('a/b').parent
    end

    it 'uses FSPath for cleanpath' do
      fspath? FSPath('a/b').cleanpath
    end

    it 'uses FSPath for expand_path' do
      fspath? FSPath('a/b').expand_path
    end

    it 'uses FSPath for relative_path_from' do
      fspath? FSPath('a').relative_path_from('b')
    end

    it 'uses FSPath for join' do
      fspath? FSPath('a').join('b', 'c')
    end

    it 'uses FSPath for split' do
      fspaths? FSPath('a/b').split
    end

    it 'uses FSPath for sub' do
      fspath? FSPath('a/b').sub('a', 'c')
      fspath? FSPath('a/b').sub('a'){ 'c' }
    end

    it 'uses FSPath for sub_ext' do
      fspath? FSPath('a/b').sub_ext('.rb')
    end if FSPath.method_defined?(:sub_ext)

    it 'uses FSPath for readlink' do
      FSPath.temp_dir do |dir|
        symlink = dir + 'sym'
        symlink.make_symlink __FILE__
        fspath? symlink.readlink
      end
    end

    it 'uses FSPath for realdirpath' do
      fspath? FSPath(__FILE__).realdirpath
    end if FSPath.method_defined?(:realdirpath)

    it 'uses FSPath for realpath' do
      fspath? FSPath(__FILE__).realpath
    end

    it 'uses FSPath for children' do
      fspaths? FSPath('.').children
    end

    it 'uses FSPath for dir_foreach' do
      dir = FSPath('.')
      allow(dir).to receive(:warn)
      dir.dir_foreach do |entry|
        fspath? entry
      end
    end if FSPath.method_defined?(:dir_foreach)

    it 'uses FSPath for each_child' do
      fspaths? FSPath('.').each_child
      fspaths? FSPath('.').each_child do |child|
        fspath? child
      end
    end if FSPath.method_defined?(:each_child)

    it 'uses FSPath for each_entry' do
      FSPath('.').each_entry do |entry|
        fspath? entry
      end
    end

    it 'uses FSPath for entries' do
      fspaths? FSPath('.').entries
    end

    it 'uses FSPath for find' do
      FSPath('.').find do |path|
        fspath? path
      end
    end

    it 'uses FSPath for inspect' do
      expect(FSPath('a').inspect).to include('FSPath')
    end
  end
end
