# encoding: UTF-8

require 'singleton'
require 'thread'

require 'progress/class_methods'
require 'progress/beeper'
require 'progress/eta'

require 'progress/kernel'
require 'progress/enumerable'
require 'progress/integer'
require 'progress/active_record' if defined?(ActiveRecord::Base)

# ==== Procedural example
#   Progress.start('Test', 1000)
#   1000.times do
#     Progress.step do
#       # do something
#     end
#   end
#   Progress.stop
# ==== Block example
#   Progress.start('Test', 1000) do
#     1000.times do
#       Progress.step do
#         # do something
#       end
#     end
#   end
# ==== Step must not always be one
#   symbols = []
#   Progress.start('Input 100 symbols', 100) do
#     while symbols.length < 100
#       input = gets.scan(/\S/)
#       symbols += input
#       Progress.step input.length
#     end
#   end
# ==== Enclosed block example
#   [1, 2, 3].each_with_progress('1 2 3') do |one_of_1_2_3|
#     10.times_with_progress('10') do |one_of_10|
#       sleep(0.001)
#     end
#   end
class Progress
  include Singleton
  extend ClassMethods

  attr_reader :total
  attr_reader :current
  attr_reader :title
  attr_accessor :note
  def initialize(total, title)
    if !total.is_a?(Numeric) && (title.nil? || title.is_a?(Numeric))
      total, title = title, total
    end
    total = total && total != 0 ? Float(total) : 1.0

    @total = total
    @current = 0.0
    @title = title
    @mutex = Mutex.new
  end

  def to_f(inner)
    inner = 1.0 if inner > 1.0
    inner *= @step if @step
    (current + inner) / total
  end

  def step(step, note)
    unless step.is_a?(Numeric)
      step, note = nil, step
    end
    step = 1 if step.nil?

    @step = step
    @note = note
    ret = yield if block_given?
    @mutex.synchronize do
      @current += step
    end
    ret
  end

  def set(new_current, note)
    @step = new_current - @current
    @note = note
    ret = yield if block_given?
    @mutex.synchronize do
      @current = new_current
    end
    ret
  end
end
