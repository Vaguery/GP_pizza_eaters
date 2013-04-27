require 'spec_helper'

describe "initialization" do
  it "takes an Array of slice weights/sizes" do
    PizzaEaters::Pizza.new([1,2,3]).slices.should == [1,2,3]
  end

  it "should default to a single slice of weight 1" do
    PizzaEaters::Pizza.new.slices.should == [1]
  end

  it "should be whole" do
    PizzaEaters::Pizza.new.should be_whole
  end
end


describe "weight" do
  it "should return the total of all remaining slices" do
    PizzaEaters::Pizza.new([1,2,3]).weight.should == 6
  end
end


describe "eating" do
  describe "eat_first_slice" do
    it "should remove the indicated slice (by index) and unfold the notionally circular whole array" do
      big = PizzaEaters::Pizza.new([1,2,3,4,5,6])
      big.eat_first_slice(3).should == 4
      big.slices.should == [5,6,1,2,3]

      little = PizzaEaters::Pizza.new([3])
      little.eat_first_slice(0).should == 3
      little.slices.should == []
    end

    it "should not be whole afterwards" do
      big = PizzaEaters::Pizza.new([1,2,3,4,5,6])
      big.eat_first_slice(1)
      big.should_not be_whole
    end
  end


  describe "eat_left_slice" do
    it "should remove the first slice from the slices array, and return its weight" do
      big = PizzaEaters::Pizza.new([1,2,3,4,5,6])
      big.eat_first_slice(3)
      lefty = big.eat_left_slice
      lefty.should be 5
      big.slices.should == [6,1,2,3]
    end
  end

  describe "eat_right_slice" do
    it "should remove the LAST slice from the slices array, and return its weight" do
      big = PizzaEaters::Pizza.new([1,2,3,4,5,6])
      big.eat_first_slice(3)
      righty = big.eat_right_slice
      righty.should be 3
      big.slices.should == [5,6,1,2]
    end
  end

  describe "eaten_all_up?" do
    it "should tell you whether the @slices array is empty" do
      PizzaEaters::Pizza.new([1,2,3]).should_not be_eaten_all_up
      PizzaEaters::Pizza.new([]).should be_eaten_all_up
    end
  end
end