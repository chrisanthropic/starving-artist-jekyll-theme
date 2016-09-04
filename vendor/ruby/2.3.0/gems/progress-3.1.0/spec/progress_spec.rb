require 'rspec'
require 'progress'
require 'tempfile'
require 'shellwords'
require 'csv'

describe Progress do
  before do
    Progress.stay_on_line = true
    Progress.highlight = true
    Progress.terminal_title = true

    allow(Progress).to receive(:start_beeper)
    allow(Progress).to receive(:time_to_print?).and_return(true)

    eta = instance_double(Progress::Eta, :left => nil, :elapsed => '0s')
    allow(Progress).to receive(:eta).and_return(eta)
  end

  describe 'integrity' do
    before do
      io = double(:<< => nil, :tty? => true)
      allow(Progress).to receive(:io).and_return(io)
    end

    it 'returns result from start block' do
      expect(Progress.start('Test') do
        'test'
      end).to eq('test')
    end

    it 'returns result from step block' do
      Progress.start 1 do
        expect(Progress.step{ 'test' }).to eq('test')
      end
    end

    it 'returns result from set block' do
      Progress.start 1 do
        expect(Progress.set(1){ 'test' }).to eq('test')
      end
    end

    it 'returns result from nested block' do
      expect([1, 2, 3].with_progress.map do |a|
        [1, 2, 3].with_progress.map do |b|
          a * b
        end
      end).to eq([[1, 2, 3], [2, 4, 6], [3, 6, 9]])
    end

    it 'does not raise errors on extra step or stop' do
      expect do
        3.times_with_progress do
          Progress.start 'simple' do
            Progress.step
            Progress.step
            Progress.step
          end
          Progress.step
          Progress.stop
        end
        Progress.step
        Progress.stop
      end.not_to raise_error
    end

    describe Enumerable do
      let(:enum){ 0...1000 }

      describe 'with_progress' do
        it 'returns with block same as when called with each' do
          expect(enum.with_progress{}).to eq(enum.with_progress.each{})
        end

        it 'does not break each' do
          reference = enum.each
          enum.with_progress.each do |n|
            expect(n).to eq(reference.next)
          end
          expect{ reference.next }.to raise_error(StopIteration)
        end

        it 'does not break find' do
          default = proc{ 'default' }
          expect(enum.with_progress.find{ |n| n == 100 }).
            to eq(enum.find{ |n| n == 100 })
          expect(enum.with_progress.find{ |n| n == 10_000 }).
            to eq(enum.find{ |n| n == 10_000 })
          expect(enum.with_progress.find(default){ |n| n == 10_000 }).
            to eq(enum.find(default){ |n| n == 10_000 })
        end

        it 'does not break map' do
          expect(enum.with_progress.map{ |n| n**2 }).to eq(enum.map{ |n| n**2 })
        end

        it 'does not break grep' do
          expect(enum.with_progress.grep(100)).to eq(enum.grep(100))
        end

        it 'does not break each_cons' do
          reference = enum.each_cons(3)
          enum.with_progress.each_cons(3) do |values|
            expect(values).to eq(reference.next)
          end
          expect{ reference.next }.to raise_error(StopIteration)
        end

        describe 'with_progress.with_progress' do
          it 'does not change existing instance' do
            wp = enum.with_progress('hello')
            expect{ wp.with_progress('world') }.not_to change(wp, :title)
          end

          it 'returns new instance with different title' do
            wp = enum.with_progress('hello')
            wp_wp = wp.with_progress('world')
            expect(wp.title).to eq('hello')
            expect(wp_wp.title).to eq('world')
            expect(wp_wp).not_to eq(wp)
            expect(wp_wp.enumerable).to eq(wp.enumerable)
          end
        end

        describe 'collections' do
          [
            [1, 2, 3],
            {1 => 1, 2 => 2, 3 => 3},
            [1, 2, 3].to_set,
          ].each do |enum|
            it "calls each only once for #{enum.class}" do
              expect(enum).to receive(:each).once.and_call_original
              expect(enum.with_progress.each{}).to eq(enum)
            end

            it "yields same objects for #{enum.class}" do
              expect(enum.with_progress.entries).to eq(enum.entries)
            end
          end

          [
            100.times,
            'a'..'z',
          ].each do |enum|
            it "calls each twice for #{enum.class}" do
              enum_each = enum.each{}
              expect(enum).to receive(:each).at_most(:twice).and_call_original
              expect(enum.with_progress.each{}).to eq(enum_each)
            end

            it "yields same objects for #{enum.class}" do
              expect(enum.with_progress.entries).to eq(enum.entries)
            end
          end
        end

        describe String do
          it 'calls each only once on StringIO' do
            enum = "a\nb\nc"
            expect(enum).not_to receive(:each)
            io = StringIO.new(enum)
            expect(StringIO).to receive(:new).with(enum).and_return(io)
            expect(io).to receive(:each).once.and_call_original

            with_progress = Progress::WithProgress.new(enum)
            expect(with_progress).not_to receive(:warn)
            expect(with_progress.each{}).to eq(enum)
          end

          it 'yields same lines' do
            enum = "a\nb\nc"
            lines = []
            Progress::WithProgress.new(enum).each{ |line| lines << line }
            expect(lines).to eq(enum.lines.to_a)
          end
        end

        describe IO do
          [
            File.open(__FILE__),
            StringIO.new(File.read(__FILE__)),
          ].each do |enum|
            it "calls each only once for #{enum.class}" do
              expect(enum).to receive(:each).once.and_call_original

              with_progress = enum.with_progress
              expect(with_progress).not_to receive(:warn)
              expect(with_progress.each{}).to eq(enum)
            end
          end

          it 'calls each only once for Tempfile' do
            enum = Tempfile.open('progress')
            enum_each = enum.each{} # returns underlying File
            expect(enum_each).to receive(:each).once.and_call_original

            with_progress = enum.with_progress
            expect(with_progress).not_to receive(:warn)
            expect(with_progress.each{}).to eq(enum_each)
          end

          it 'calls each only once for IO and shows warning' do
            enum = IO.popen("cat #{__FILE__.shellescape}")
            expect(enum).to receive(:each).once.and_call_original

            with_progress = enum.with_progress
            expect(with_progress).to receive(:warn)
            expect(with_progress.each{}).to eq(enum)
          end

          [
            File.open(__FILE__),
            StringIO.new(File.read(__FILE__)),
            Tempfile.open('progress').tap do |f|
              f.write(File.read(__FILE__))
              f.rewind
            end,
            IO.popen("cat #{__FILE__.shellescape}"),
          ].each do |enum|
            it "yields same lines for #{enum.class}" do
              expect(enum.with_progress.entries).to eq(File.readlines(__FILE__))
            end
          end
        end

        describe CSV do
          if CSV.method_defined?(:pos)
            it 'calls each only once for CSV' do
              enum = CSV.open('spec/test.csv')
              expect(enum).to receive(:each).once.and_call_original

              with_progress = enum.with_progress
              expect(with_progress).not_to receive(:warn)
              expect(with_progress.each{}).to eq(nil)
            end
          else
            it 'calls each only once for CSV and shows warning' do
              enum = CSV.open('spec/test.csv', 'r')
              expect(enum).to receive(:each).once.and_call_original

              with_progress = enum.with_progress
              expect(with_progress).to receive(:warn)
              expect(with_progress.each{}).to eq(enum)
            end
          end

          it 'yields same lines for CSV' do
            csv = proc{ CSV.open('spec/test.csv', 'r') }
            expect(csv[].with_progress.entries).to eq(csv[].entries)
          end
        end
      end
    end

    describe Integer do
      let(:count){ 108 }

      it 'does not break times_with_progress' do
        reference = count.times
        count.times_with_progress do |i|
          expect(i).to eq(reference.next)
        end
        expect{ reference.next }.to raise_error(StopIteration)
      end

      it 'does not break times.with_progress' do
        reference = count.times
        count.times.with_progress do |i|
          expect(i).to eq(reference.next)
        end
        expect{ reference.next }.to raise_error(StopIteration)
      end
    end
  end

  describe 'output' do
    def stub_progress_io(io)
      allow(io).to receive(:tty?).and_return(true)
      allow(Progress).to receive(:io).and_return(io)
    end

    describe 'validity' do
      def run_example_progress
        Progress.start 5, 'Test' do
          Progress.step 2, 'simle'

          Progress.step 2, 'times' do
            3.times.with_progress{}
          end

          Progress.step 'enum' do
            3.times.to_a.with_progress{}
          end
        end
      end

      def title(s)
        "\e]0;#{s}\a"
      end

      def hl(s)
        "\e[1m#{s}\e[0m"
      end

      def unhl(s)
        s.gsub(/\e\[\dm/, '')
      end

      def on_line(s)
        "\r" + s + "\e[K"
      end

      def line(s)
        s + "\n"
      end

      def on_line_n_title(s)
        [on_line(s), title(unhl(s))]
      end

      def line_n_title(s)
        [line(s), title(unhl(s))]
      end

      it 'produces valid output when staying on line' do
        Progress.stay_on_line = true

        stub_progress_io(io = StringIO.new)
        run_example_progress

        expect(io.string).to eq([
          on_line_n_title("Test: #{hl '......'}"),
          on_line_n_title("Test: #{hl ' 40.0%'} - simle"),
          on_line_n_title("Test: #{hl ' 40.0%'} > #{hl '......'}"),
          on_line_n_title("Test: #{hl ' 53.3%'} > #{hl ' 33.3%'}"),
          on_line_n_title("Test: #{hl ' 66.7%'} > #{hl ' 66.7%'}"),
          on_line_n_title("Test: #{hl ' 80.0%'} > 100.0%"),
          on_line_n_title("Test: #{hl ' 80.0%'} - times"),
          on_line_n_title("Test: #{hl ' 80.0%'} > #{hl '......'}"),
          on_line_n_title("Test: #{hl ' 86.7%'} > #{hl ' 33.3%'}"),
          on_line_n_title("Test: #{hl ' 93.3%'} > #{hl ' 66.7%'}"),
          on_line_n_title('Test: 100.0% > 100.0%'),
          on_line_n_title('Test: 100.0% - enum'),
          on_line('Test: 100.0% (elapsed: 0s) - enum') + "\n",
          title(''),
        ].flatten.join)
      end

      it 'produces valid output when not staying on line' do
        Progress.stay_on_line = false

        stub_progress_io(io = StringIO.new)
        run_example_progress

        expect(io.string).to eq([
          line_n_title("Test: #{hl '......'}"),
          line_n_title("Test: #{hl ' 40.0%'} - simle"),
          line_n_title("Test: #{hl ' 40.0%'} > #{hl '......'}"),
          line_n_title("Test: #{hl ' 53.3%'} > #{hl ' 33.3%'}"),
          line_n_title("Test: #{hl ' 66.7%'} > #{hl ' 66.7%'}"),
          line_n_title("Test: #{hl ' 80.0%'} > 100.0%"),
          line_n_title("Test: #{hl ' 80.0%'} - times"),
          line_n_title("Test: #{hl ' 80.0%'} > #{hl '......'}"),
          line_n_title("Test: #{hl ' 86.7%'} > #{hl ' 33.3%'}"),
          line_n_title("Test: #{hl ' 93.3%'} > #{hl ' 66.7%'}"),
          line_n_title('Test: 100.0% > 100.0%'),
          line_n_title('Test: 100.0% - enum'),
          line('Test: 100.0% (elapsed: 0s) - enum'),
          title(''),
        ].flatten.join)
      end
    end

    describe 'different call styles' do
      let(:count_a){ 13 }
      let(:count_b){ 17 }
      let(:reference_output) do
        stub_progress_io(reference_io = StringIO.new)
        count_a.times.with_progress('Test') do
          count_b.times.with_progress{}
        end
        reference_io.string
      end
      let(:io){ StringIO.new }

      before do
        stub_progress_io(io)
      end

      it 'outputs same when called without block' do
        Progress(count_a, 'Test')
        count_a.times do
          Progress.step do
            Progress.start(count_b)
            count_b.times do
              Progress.step
            end
            Progress.stop
          end
        end
        Progress.stop
        expect(io.string).to eq(reference_output)
      end

      it 'outputs same when called with block' do
        Progress(count_a, 'Test') do
          count_a.times do
            Progress.step do
              Progress.start(count_b) do
                count_b.times do
                  Progress.step
                end
              end
            end
          end
        end
        expect(io.string).to eq(reference_output)
      end

      it 'outputs same when called using with_progress on list' do
        count_a.times.to_a.with_progress('Test') do
          count_b.times.to_a.with_progress{}
        end
        expect(io.string).to eq(reference_output)
      end
    end
  end
end
