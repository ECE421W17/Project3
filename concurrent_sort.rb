require 'test/unit/assertions'

include Test::Unit::Assertions

module ConcurrentSort
  # TODO: Determine if this is needed.
  # => If so, will need to use a class instead of a module.
  def self._assert_class_invariants()
  end

  def self._verify_sort_pre_conditions(duration, *objects, comparison_function)
    assert(duration.respond_to?(:to_i), "The given duration is not an integer")
    assert(duration.to_i >= 0, "The given duration is a negative value")
    assert(comparison_function.arity == 2,
      "The given comparison function must accept exactly two arguments")
  end

  def self._verify_sort_post_conditions()
  end

  def self.sort(duration, *objects, comparison_function)
    _verify_sort_pre_conditions(duration, objects, comparison_function)

    # TODO: Implement properly; using bubble sort to test
    for i in 0..objects.length - 1
      acme = objects[i]
      for j in i..objects.length - 1
        if comparison_function.call(objects[j], acme)
          objects[i] = objects[j]
          objects[j] = acme
          acme = objects[i]
        end
      end
    end

    _verify_sort_post_conditions()

    return objects
  end

  # TODO: Add a method to indicate whether the algorithm completed sorting?
  # => If so, we'll need to use a class instead of a module; we'll need state.
  def finished?
  end
end
