# TODO: Remove this file - just needed for testing
#require_relative 'concurrent_sort'

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

  def <=>(other_object)
    if self < other_object
      return -1
    end

    if self > other_object
      return 1
    end

    return 0
  end

  def to_s
    @val.to_s
  end
end


