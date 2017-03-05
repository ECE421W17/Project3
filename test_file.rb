# TODO: Remove
require_relative 'concurrent_sort'

puts 'Hello'

class TestObject
  def initialize(val)
    @val = val
  end

  def <(other_object)
    return @val < other_object.get_instance_variable('@val')
  end
end

o1 = TestObject.new(1)
o2 = TestObject.new(2)

test = ConcurrentSort.new(o1, o2, 5)

test.sort

while test.status
  puts 'Waiting...'
end
