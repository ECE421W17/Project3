# This file contains test code for our module.
# To use the module in your code base, include concurrent_sort
# and call ConcurrentSort.sort(duration, objects, comparison_function)
#
# Group members:
#
# Andrew Lawrence - adlawren
# Derek Shultz    - dshultz
# Rui Wu          - rwu4
# Vitor Mendonca  - mendona

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
	ConcurrentSort.sort(0.00001, objects)
rescue Timeout::Error
	puts "Timeout error. No sorting done, return original list"
end
puts objects

puts "Sorting 1000 random integers into file test1.txt"
objects = Array.new(1000) {rand(100000)  }
begin
	ConcurrentSort.sort(10, objects)
	File.open('test1.txt', 'w'){|file| file.write(objects)}
rescue Timeout::Error
	puts "Timeout error. No sorting done, return original list"
end

puts "Sorting 2000 random integers into file test2.txt"
objects = Array.new(2000) {rand(10000000)  }
begin
	ConcurrentSort.sort(10, objects)
	File.open('test2.txt', 'w'){|file| file.write(objects)}
rescue Timeout::Error
	puts "Timeout error. No sorting done, return original list"
end

puts "Sorting custom TestObject class"
o1 = TestObject.new(1)
o2 = TestObject.new(2)
o3 = TestObject.new(3)

#objects = [4, 3, 2, 1]
objects = [o2, o1, o3]
begin
  ConcurrentSort.sort(5, objects, lambda {
  |object1, object2| return object1 > object2
  })
rescue Timeout::Error
	puts "no sorting done, return original list"
end
puts objects

puts "Sorting strings by default (<=)"
objects = ["zxx", "yxxxxx", "x"]
begin
  ConcurrentSort.sort(5, objects)
rescue Timeout::Error
	puts "no sorting done, return original list"
end
puts objects

puts "Sorting strings by length"
objects = ["zxx", "yxxxxx", "x"]
begin
  ConcurrentSort.sort(5, objects, lambda {
    |object1, object2| object1.length < object2.length
    })
rescue Timeout::Error
	puts "no sorting done, return original list"
end
puts objects
