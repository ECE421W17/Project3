require 'test/unit/assertions'

include Test::Unit::Assertions

module ConcurrentSortContract
  def _verify_initialize_pre_conditions()
    puts 'a'
  end

  def _verify_initialize_post_conditions()
    puts 'a'
  end

  def _verify_sort_pre_conditions()
    # assert()
  end

  def _verify_sort_post_conditions()
    # assert()
  end
end
