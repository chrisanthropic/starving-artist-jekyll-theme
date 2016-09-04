require 'spec_helper'
require 'image_optim/pack'

describe ImageOptim::Pack do
  before do
    stub_const('Pack', ImageOptim::Pack)
    stub_const('Path', Pack::Path)
  end

  describe :path do
    it 'returns path' do
      expect(Pack.path).to be
    end

    it 'returns instance of Path' do
      expect(Pack.path).to be_an(Path)
    end

    it 'yields debug messages' do
      expect{ |block| Pack.path(&block) }.
        to yield_with_args(/^image_optim_pack: all bins .* worked$/)
    end
  end

  describe ImageOptim::Pack::Path do
    describe :path do
      it 'returns FSPath with path' do
        expect(Path.new('path').path).to eq(FSPath('path'))
      end
    end

    describe :to_s do
      it 'returns stringified path' do
        expect(Path.new(Pathname('path')).to_s).to eq('path')
      end
    end

    describe :os do
      it 'returns last but one part of path' do
        expect(Path.new('path/futureos-K-qbit').os).to eq('futureos')
      end
    end

    describe :arch do
      it 'returns last but one part of path' do
        expect(Path.new('path/futureos-K-qbit').arch).to eq('K-qbit')
      end
    end

    describe :bins do
      subject{ Pack.path.bins }

      define :be_non_libraries do
        match do |bin|
          bin.name !~ /^lib/
        end
      end

      it{ should be_an(Array) }

      it{ should_not be_empty }

      it{ should all(be_an(ImageOptim::BinResolver::Bin)) }

      it{ should all(have_attributes(:version => be)) }

      it{ should all(be_non_libraries) }
    end

    describe 'bin helpers' do
      def bins_with_versions(*versions)
        versions.map do |version|
          double(:version => version, :inspect => version ? 'good' : 'bad')
        end
      end

      def path_with_bins(*bins)
        path = Path.new('path')
        allow(path).to receive(:bins).and_return(bins)
        path
      end

      describe 'all good bins' do
        let(:bins){ bins_with_versions('1.3', '6.1.6') }
        subject{ path_with_bins(*bins) }

        it{ should be_all_bins_working }
        it{ should_not be_all_bins_failing }
        it{ should have_attributes(:working_bins => eq(bins)) }
        it{ should have_attributes(:failing_bins => be_empty) }
      end

      describe 'mixed good/bad bins' do
        let(:bins){ bins_with_versions('1.3', nil, '6.1.6', nil) }
        subject{ path_with_bins(*bins) }

        it{ should_not be_all_bins_working }
        it{ should_not be_all_bins_failing }
        it{ should have_attributes(:working_bins => bins.select(&:version)) }
        it{ should have_attributes(:failing_bins => bins.reject(&:version)) }
      end

      describe 'all bad bins' do
        let(:bins){ bins_with_versions(nil, nil) }
        subject{ path_with_bins(*bins) }

        it{ should_not be_all_bins_working }
        it{ should be_all_bins_failing }
        it{ should have_attributes(:working_bins => be_empty) }
        it{ should have_attributes(:failing_bins => eq(bins)) }
      end
    end
  end
end
