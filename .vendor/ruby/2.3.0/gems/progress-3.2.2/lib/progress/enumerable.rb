require 'enumerator'
require 'progress/with_progress'

# Add with_progress method to Enumerable
module Enumerable
  # run any Enumerable method with progress
  # methods which don't necessarily go through all items (like find, any? or
  # all?) will not show 100%
  # ==== Example
  #   [1, 2, 3].with_progress('Numbers').each do |number|
  #     # code
  #   end
  #
  #   [1, 2, 3].with_progress('Numbers').each_cons(2) do |numbers|
  #     # code
  #   end
  #
  #   (0...100).with_progress('Numbers').select do |numbers|
  #     # code
  #   end
  #
  #   (0...100).with_progress('Numbers').all? do |numbers|
  #     # code
  #   end
  def with_progress(title = nil, length = nil, &block)
    Progress::WithProgress.new(self, title, length, &block)
  end
end
