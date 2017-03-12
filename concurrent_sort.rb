require 'test/unit/assertions'
require_relative 'parallelmergesort'
require 'timeout'

include Test::Unit::Assertions

module ConcurrentSort
  def self._verify_sort_pre_conditions(duration, objects, comparison_function)
    assert(duration.respond_to?(:to_i), "The given duration is not an integer")
    assert(duration.to_i >= 0, "The given duration is a negative value")
    assert(duration != 0, "The given duration is zero (same as infinite), which isn't allowed")
    assert(objects.respond_to?(:[]), "Contents cannot overload [] operator")
    assert(objects.respond_to?(:length),
      "The collection must implement a 'length' method")
    assert(objects.length > 0, "Do not accept null lists")
    if comparison_function != nil
      assert(comparison_function.arity == 2,
        "The given comparison function must accept exactly two arguments")
    end
  end

  def self._verify_sort_post_conditions(objects, originalLength)
    assert(objects.length == originalLength, "The length of the element list has changed")
  end

  def self.sort(duration, objects, comparison_function = nil)
    _verify_sort_pre_conditions(duration, objects, comparison_function)

    #TODO: decide what to do for backward recovery, for now, make a copy of the orginal list 
    backupList = objects.dup
    originalLength = objects.length

    #replace bubble sort with merge sort
    begin
      status = Timeout::timeout(duration){
        ParallelMergeSort.mergesort(objects, 0, objects.length-1)
      }
      _verify_sort_post_conditions(objects, originalLength)
      return objects
    rescue Timeout::Error
      puts "Timeout error, no sorting has been done"
      _verify_sort_post_conditions(backupList, originalLength)
      return backupList
    end
  end
end
