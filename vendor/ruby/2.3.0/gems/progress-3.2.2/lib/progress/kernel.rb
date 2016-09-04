require 'progress'

# Add Progress method as alias to Progress.start
module Kernel
  define_method :Progress do |*args, &block|
    Progress.start(*args, &block)
  end
  private :Progress
end
