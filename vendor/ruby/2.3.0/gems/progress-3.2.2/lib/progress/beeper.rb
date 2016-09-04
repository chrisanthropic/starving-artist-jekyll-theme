class Progress
  # Repeatedly run block of code after time interval
  class Beeper
    def initialize(time)
      @thread = Thread.new do
        loop do
          @skip = false
          sleep time
          yield unless @skip
        end
      end
    end

    def restart
      @skip = true
      @thread.run
    end

    def stop
      @thread.kill
    end
  end
end
