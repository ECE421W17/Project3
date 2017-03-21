require 'test/unit/assertions'
require_relative 'parallelmergesort'
require 'timeout'

include Test::Unit::Assertions

module ConcurrentSort
  def self._verify_sort_pre_conditions(duration, objects, comparison_function)
    assert(duration.respond_to?(:to_i), "The given duration is not an integer")
    assert(duration.to_i >= 0, "The given duration is a negative value")
    assert(objects.respond_to?(:[]), "Contents cannot overload [] operator")
    assert(objects.respond_to?(:length),
      "The collection must implement a 'length' method")
    assert(objects, "Do not accept null collections")
    assert(!objects.empty?, "Do not accept empty collections")
    assert(comparison_function.arity == 2,
      "The given comparison function must accept exactly two arguments")
  end

  def self._verify_sort_post_conditions(objects, originalLength)
    assert(objects.length == originalLength, "The length of the element list has changed")
  end

  def self.sort(duration, objects, comparison_function = lambda {|x, y| x <= y})
    _verify_sort_pre_conditions(duration, objects, comparison_function)

    originalLength = objects.length
    backupList = Array.new(originalLength)
    (0..originalLength-1).each do |i|
      backupList[i] = objects[i]
    end
    begin
      Timeout::timeout(duration) do
        ParallelMergeSort.mergesort(objects, 0, objects.length-1, comparison_function)
      end
      _verify_sort_post_conditions(objects, originalLength)
    rescue Timeout::Error
      ParallelMergeSort.rescue(objects, backupList)
      raise Timeout::Error
    end
  end
end
