require 'fspath'

describe FSPath do
  class ZPath < FSPath; end

  # check_have_symlink? from test/fileutils/test_fileutils.rb
  def self.symlinks_supported?
    File.symlink '', ''
  rescue NotImplementedError, Errno::EACCES
    false
  rescue
    true
  end

  it 'inherits from Pathname' do
    expect(FSPath.new('.')).to be_kind_of(Pathname)
  end

  it 'uses shortcut' do
    expect(FSPath('.')).to eql(FSPath.new('.'))
  end

  describe '.~' do
    it 'returns current user home directory' do
      expect(File).to receive(:expand_path).
        with('~').and_return('/home/this')

      expect(FSPath.~).to eq(FSPath('/home/this'))
    end

    it 'returns other user home directory' do
      expect(File).to receive(:expand_path).
        with('~root').and_return('/home/root')

      expect(FSPath.~('root')).to eq(FSPath('/home/root'))
    end
  end

  describe '.common_dir' do
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

  describe '.temp_file' do
    [FSPath, ZPath].each do |klass|
      context "when called on #{klass}" do
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
      end
    end

    it 'returns result of block' do
      expect(FSPath.temp_file{ :result }).to eq(:result)
    end

    it 'calls appropriate initializer (jruby 1.8 mode bug)' do
      expect do
        FSPath.temp_file('abc', '.'){}
      end.not_to raise_error
    end
  end

  describe '.temp_file_path' do
    [FSPath, ZPath].each do |klass|
      context "when called on #{klass}" do
        it "returns an instance of #{klass} with temporary path" do
          expect(klass.temp_file_path).to be_kind_of(klass)
        end

        it "yields an instance of #{klass} with temporary path" do
          yielded = nil
          klass.temp_file_path{ |y| yielded = y }
          expect(yielded).to be_kind_of(klass)
        end
      end
    end

    it 'does not allow GC to finalize TempFile' do
      paths = Array.new(1000){ FSPath.temp_file_path }
      expect(paths).to be_all(&:exist?)
      GC.start
      expect(paths).to be_all(&:exist?)
    end

    it 'returns result of block' do
      expect(FSPath.temp_file_path{ :result }).to eq(:result)
    end

    describe 'closing file handle' do
      before do
        @tempfile = nil
        allow(FSPath::Tempfile).to receive(:new).once.
          and_wrap_original{ |m, *args| @tempfile = m.call(*args) }
      end

      it 'closes the file handle, but does not unlink path before return' do
        path = FSPath.temp_file_path
        expect(@tempfile).to be_closed
        expect(path).to exist
      end

      it 'closes the file handle, but does not unlink path before yield' do
        FSPath.temp_file_path do |path|
          expect(@tempfile).to be_closed
          expect(path).to exist
        end
      end
    end
  end

  describe '.temp_dir' do
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

  describe '#/' do
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

  describe '#+' do
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

  describe '#relative_path_from' do
    it 'returns instance of FSPath' do
      expect(FSPath('a').relative_path_from('b')).to be_instance_of(FSPath)
    end

    it 'returns relative path' do
      expect(FSPath('b/a').relative_path_from('b')).to eq(FSPath('a'))
    end
  end

  describe 'read/write' do
    let(:path){ FSPath.temp_file_path }
    let(:crlf_text){ "a\nb\rc\r\nd" }
    let(:described_method){ |example| example.full_description[/#(\S+)/, 1] }

    def binread(path)
      path.open('rb', &:read)
    end

    def binwrite(path, data)
      path.open('wb'){ |f| f.write(data) }
    end

    describe '#binread' do
      it 'reads data' do
        binwrite(path, 'data')
        expect(path.binread).to eq('data')
      end

      it 'limits data when length is set' do
        binwrite(path, 'data')
        expect(path.binread(3)).to eq('dat')
      end

      it 'skips data when offset is set' do
        binwrite(path, 'data')
        expect(path.binread(nil, 1)).to eq('ata')
      end

      it 'skips and limits data when length and offset are set' do
        binwrite(path, 'data')
        expect(path.binread(2, 1)).to eq('at')
      end

      it 'opens file in binary mode' do
        binwrite(path, crlf_text)
        expect(path.binread).to eq(crlf_text)
      end
    end

    shared_examples 'writing' do
      it 'writes data' do
        path.send(described_method, 'data')
        expect(path.read).to eq('data')
      end

      it 'returns the length of data written' do
        expect(path.send(described_method, 'data')).to eq(4)
      end
    end

    shared_examples 'overwriting' do
      context 'when offset is not specified' do
        it 'overwrites file' do
          path.send(described_method, 'longer data')
          path.send(described_method, 'data')
          expect(path.read).to eq('data')
        end
      end

      context 'when offset is specified' do
        it 'overwrites part of file and does not truncate it' do
          path.send(described_method, 'longer data')
          path.send(described_method, 'data', 2)
          expect(path.read).to eq('lodata data')
        end
      end
    end

    shared_examples 'appending' do
      it 'appends data to the end of file' do
        path.send(described_method, 'data')
        path.send(described_method, 'more data')
        expect(path.read).to eq('datamore data')
      end
    end

    shared_examples 'writes in text mode' do
      it 'opens file in text mode' do
        test_path = FSPath.temp_file_path
        test_path.open('w'){ |f| f.write(crlf_text) }

        path.send(described_method, crlf_text)
        expect(binread(path)).to eq(binread(test_path))
      end
    end

    shared_examples 'writes in binary mode' do
      it 'opens file in binary mode' do
        test_path = FSPath.temp_file_path
        test_path.open('wb'){ |f| f.write(crlf_text) }

        path.send(described_method, crlf_text)
        expect(binread(path)).to eq(binread(test_path))
      end
    end

    describe '#write' do
      include_examples 'writing'
      include_examples 'overwriting'
      include_examples 'writes in text mode'
    end

    describe '#binwrite' do
      include_examples 'writing'
      include_examples 'overwriting'
      include_examples 'writes in binary mode'
    end

    describe '#append' do
      include_examples 'writing'
      include_examples 'appending'
      include_examples 'writes in text mode'
    end

    describe '#binappend' do
      include_examples 'writing'
      include_examples 'appending'
      include_examples 'writes in binary mode'
    end
  end

  describe '#escape_glob' do
    it 'escapes glob pattern characters' do
      expect(FSPath('*/**/?[a-z]{abc,def}').escape_glob).
        to eq(FSPath('\*/\*\*/\?\[a-z\]\{abc,def\}'))
    end
  end

  describe '#glob' do
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
      let(:path){ FSPath('/a/b/c') }
      let(:expected){ %w[/a/b/c /a/b /a /].map(&method(:FSPath)) }

      describe '#ascendants' do
        it 'returns list of ascendants' do
          expect(path.ascendants).to eq(expected)
        end
      end

      describe '#ascend' do
        it 'returns list of ascendants' do
          expect(path.ascend).to eq(expected)
        end

        it 'yields and returns list of ascendants if called with block' do
          ascendants = []
          expect(path.ascend do |sub_path|
            ascendants << sub_path
          end).to eq(expected)
          expect(ascendants).to eq(expected)
        end
      end
    end

    describe 'descending' do
      let(:path){ FSPath('/a/b/c') }
      let(:expected){ %w[/ /a /a/b /a/b/c].map(&method(:FSPath)) }

      describe '#descendants' do
        it 'returns list of descendants' do
          expect(path.descendants).to eq(expected)
        end
      end

      describe '#descend' do
        it 'returns list of descendants' do
          expect(path.descend).to eq(expected)
        end

        it 'yields and returns list of descendants if called with block' do
          descendants = []
          expect(path.descend do |sub_path|
            descendants << sub_path
          end).to eq(expected)
          expect(descendants).to eq(expected)
        end
      end
    end

    describe '#parts' do
      it 'returns path parts for absolute path' do
        expect(FSPath('/a/b/c').parts).to eq(%w[/ a b c])
      end

      it 'returns path parts for relative path' do
        expect(FSPath('a/b/c').parts).to eq(%w[a b c])
      end

      it 'returns path parts for path prefixed with .' do
        expect(FSPath('./a/b/c').parts).to eq(%w[. a b c])
      end

      it 'returns path parts for path containing ..' do
        expect(FSPath('a/../b/c').parts).to eq(%w[a .. b c])
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
    end if symlinks_supported?

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
