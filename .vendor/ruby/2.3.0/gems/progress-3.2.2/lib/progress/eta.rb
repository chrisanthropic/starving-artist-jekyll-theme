class Progress
  # Estimate time of arrival
  class Eta
    def initialize
      @started_at = Time.now
    end

    def left(completed)
      seconds = seconds_left(completed)
      return unless seconds && seconds > 0
      seconds_to_string(seconds)
    end

    def elapsed
      seconds_to_string(Time.now - @started_at)
    end

  private

    def seconds_to_string(seconds)
      return unless seconds
      case seconds
      when 0...60
        format '%.0fs', seconds
      when 60...3600
        format '%.1fm', seconds / 60
      when 3600...86_400
        format '%.1fh', seconds / 3600
      else
        format '%.1fd', seconds / 86_400
      end
    end

    def seconds_left(completed)
      now = Time.now
      return unless completed > 0 && now - @started_at >= 1
      current_eta = @started_at + (now - @started_at) / completed
      @left = if @left
        @left + (current_eta - @left) * (1 + completed) * 0.5
      else
        current_eta
      end
      @left - now
    end
  end
end
