class Pizza
	attr_accessor :slices
  attr_accessor :whole

  def slice(size_array)
    @slices = size_array
    @whole = true
  end

  def whole?
    whole
  end

  def eat_first_slice(which)
    open_circle = @slices[which+1..-1] + @slices[0...which]
    @slices = open_circle
    @whole = false
  end

  def left_slice
    @slices[0]
  end

  def right_slice
    @slices[-1]
  end
end