# TODO: Find a way to just use 'require'?
require_relative 'concurrent_sort_contract'

class ConcurrentSort
  include ConcurrentSortContract

  def initialize(
    comparison_function = lambda {
      |object1, object2| return object1 < object2
      }, *objects, duration)
    _verify_initialize_pre_conditions

    @duration = duration
    @comparison_function = comparison_function
    @objects = objects

    @child_sort_process_pid = -1

    _verify_initialize_pre_conditions
  end

  def sort
    _verify_sort_pre_conditions

    # TODO: Implement properly; using bubble sort to test
    @child_sort_process_pid = Process.fork do
      # Do stuff...

      sleep(3)
    end

    Process.detach @child_sort_process_pid

    _verify_sort_post_conditions
  end

  # TODO: Decide what this is going to look like
  def finished?
    # ...

    begin
      Process.kill 0, @child_sort_process_pid
      return false
    rescue Errno::ESRCH
      return true
    end

    # ...
  end
end
