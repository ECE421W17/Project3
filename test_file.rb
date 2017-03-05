# TODO: Remove this file - just needed for testing
require_relative 'concurrent_sort'

class TestObject
  def initialize(val)
    @val = val
  end

  def <(other_object)
    return @val < other_object.instance_variable_get('@val')
  end

  def >(other_object)
    less_than = self < other_object
    return !less_than
  end

  def to_s
    @val.to_s
  end
end

o1 = TestObject.new(1)
o2 = TestObject.new(2)
o3 = TestObject.new(3)

# objects = [4, 3, 2, 1]
objects = [o2, o1, o3]
res = ConcurrentSort.sort(5, *objects, lambda {
  |object1, object2| return object1 < object2
  })

puts res
