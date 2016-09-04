# encoding: UTF-8

class Progress
  # Class methods of Progress
  module ClassMethods
    def self.extended(klass)
      klass.instance_variable_set(:@lock, Mutex.new)
    end

    # start progress indication
    def start(total = nil, title = nil)
      init(total, title)
      print_message :force => true
      return unless block_given?
      begin
        yield
      ensure
        stop
      end
    end

    # step current progress
    def step(step = nil, note = nil, &block)
      if running?
        ret = @levels.last.step(step, note, &block)
        print_message
        ret
      elsif block
        yield
      end
    end

    # set value of current progress
    def set(new_current, note = nil, &block)
      if running?
        ret = @levels.last.set(new_current, note, &block)
        print_message
        ret
      elsif block
        yield
      end
    end

    # stop progress
    def stop
      return unless running?
      if @levels.length == 1
        print_message :force => true, :finish => true
        stop_beeper
      end
      @levels.pop
    end

    # check if progress was started
    def running?
      @levels && !@levels.empty?
    end

    # set note
    def note=(note)
      return unless running?
      @levels.last.note = note
    end

    # stay on one line
    def stay_on_line?
      @stay_on_line.nil? ? io_tty? : @stay_on_line
    end

    # explicitly set staying on one line [true/false/nil]
    def stay_on_line=(value)
      @stay_on_line = true && value
    end

    # highlight output using control characters
    def highlight?
      @highlight.nil? ? io_tty? : @highlight
    end

    # explicitly set highlighting [true/false/nil]
    def highlight=(value)
      @highlight = true && value
    end

    # show progerss in terminal title
    def terminal_title?
      @terminal_title.nil? ? io_tty? : @terminal_title
    end

    # explicitly set showing progress in terminal title [true/false/nil]
    def terminal_title=(value)
      @terminal_title = true && value
    end

  private

    attr_reader :eta

    def init(total = nil, title = nil)
      lock do
        if running?
          unless @started_in == Thread.current
            warn 'Can\'t start inner progress in different thread'
            return block_given? ? yield : nil
          end
        else
          @started_in = Thread.current
          @eta = Eta.new
          start_beeper
        end
        @levels ||= []
        @levels.push new(total, title)
      end
    end

    def lock(force = true)
      if force
        @lock.lock
      else
        return unless @lock.try_lock
      end

      begin
        yield
      ensure
        @lock.unlock
      end
    end

    def io
      @io || $stderr
    end

    def io_tty?
      io.tty? || ENV['PROGRESS_TTY']
    end

    def start_beeper
      @beeper = Beeper.new(10) do
        print_message
      end
    end

    def stop_beeper
      @beeper.stop if @beeper
    end

    def restart_beeper
      @beeper.restart if @beeper
    end

    def time_to_print?
      !@next_time_to_print || @next_time_to_print <= Time.now
    end

    def print_message(options = {})
      force = options[:force]
      lock force do
        if force || time_to_print?
          @next_time_to_print = Time.now + 0.3
          restart_beeper
          io << message_for_output(options)
        end
      end
    end

    def message_for_output(options)
      message = build_message(options)

      out = ''
      out << "\r" if stay_on_line?
      out << message
      out << "\e[K" if stay_on_line?
      out << "\n" if !stay_on_line? || options[:finish]

      if terminal_title?
        out << "\e]0;"
        unless options[:finish]
          out << message.gsub(/\e\[\dm/, '').tr("\a", '␇')
        end
        out << "\a"
      end

      out
    end

    def build_message(options)
      current = 0
      message = @levels.reverse.map do |level|
        current = level.to_f(current)

        part = current.zero? ? '......' : format('%5.1f%%', current * 100.0)

        if highlight? && part != '100.0%'
          part = "\e[1m#{part}\e[0m"
        end

        level.title ? "#{level.title}: #{part}" : part
      end.reverse * ' > '

      if options[:finish]
        message << " (elapsed: #{eta.elapsed})"
      elsif (left = eta.left(current))
        message << " (ETA: #{left})"
      end

      if running? && (note = @levels.last.note)
        message << " - #{note}"
      end

      message
    end
  end
end
