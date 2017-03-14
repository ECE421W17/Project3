require_relative 'parallelmergesort'
require_relative 'concurrent_sort'
require_relative 'test_file'

puts "Test with integer arrays, expect: finish sorting"
objects = [-3, 342, 3434, 343, -1222,345932,49495, 340201, 3030021, 11, 0, -1343, -123455]
begin
	ConcurrentSort.sort(1, objects)
rescue Timeout::Error
	puts "No soring done, return original list"
end
puts objects

puts "Test with integer arrays, expect: timeout error, no sorting have been done, return original list"
objects = [-3, 342, 3434, 343, -1222, 345932, 49495, 340201, 3030021, 11, 0, -1343, -123455]
begin
	ConcurrentSort.sort(0.001, objects)
rescue Timeout::Error
	puts "Timeout error. No sorting done, return original list"
end
puts objects

o1 = TestObject.new(1)
o2 = TestObject.new(2)
o3 = TestObject.new(3)

#objects = [4, 3, 2, 1]
objects = [o2, o1, o3]
begin
	ConcurrentSort.sort(5, objects, lambda {
  |object1, object2| return object1 < object2
  })
rescue Timeout::Error
	puts "no sorting done, return original list"
end
puts objects
