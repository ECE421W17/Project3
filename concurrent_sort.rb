require 'test/unit/assertions'

include Test::Unit::Assertions

module ConcurrentSort
  def self._verify_sort_pre_conditions(duration, objects, comparison_function)
    assert(duration.respond_to?(:to_i), "The given duration is not an integer")
    assert(duration.to_i >= 0, "The given duration is a negative value")
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
    assert(objects.length == originalLength, "the length of the element list is changed")

  end

  def self.sort(duration, objects, comparison_function = nil)
    _verify_sort_pre_conditions(duration, objects, comparison_function)

    originalLength = objects.length

    # TODO: Implement properly; using bubble sort to test
    for i in 0..objects.length - 1
      acme = objects[i]
      for j in i..objects.length - 1
        if comparison_function != nil
          if comparison_function.call(objects[j], acme)
            objects[i] = objects[j]
            objects[j] = acme
            acme = objects[i]
          end
        else
          if objects[j] < acme
            objects[i] = objects[j]
            objects[j] = acme
            acme = objects[i]
          end
        end
      end
    end

    _verify_sort_post_conditions(objects, originalLength)
    return objects
  end
end
