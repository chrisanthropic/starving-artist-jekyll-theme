require 'progress'

# Add times_with_progress method to Integer
class Integer
  # run `times` with progress
  #   100.times_with_progress('Numbers') do |number|
  #     # code
  #   end
  def times_with_progress(title = nil)
    Progress.start(title, self) do
      times do |i|
        Progress.step do
          yield i
        end
      end
    end
  end
end
