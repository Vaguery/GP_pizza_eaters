require 'spec_helper'

describe "Interpreter" do

  before(:each) do
    @pizza = PizzaEaters::Pizza.new([1,2,3,4])
  end
  
  describe "initialization" do
    it "should take a Pizza object as an argument" do
      sliced_4_ways = PizzaEaters::Interpreter.new(@pizza)
      sliced_4_ways.pizza.should == @pizza
    end
  end


  describe "run" do
    it "should use the pizza to create the empty stacks" do
      sliced_4_ways = PizzaEaters::Interpreter.new(@pizza)
      sliced_4_ways.run("foo")
      sliced_4_ways.stacks.length.should == 4
      sliced_4_ways.stacks.should == [[],[],[],[]]
    end

    it "should break the script passed in as an argument into a token array" do
      script = "a b c d"
      words = script.split
      sliced_4_ways = PizzaEaters::Interpreter.new(@pizza)
      script.should_receive(:strip).and_return(script)
      script.should_receive(:split).and_return(words)
      sliced_4_ways.run(script)
    end

    it "should interpret each token" do
      script = "a b c"
      sliced_4_ways = PizzaEaters::Interpreter.new(@pizza)
      sliced_4_ways.should_receive(:interpret_token).exactly(3).times
      sliced_4_ways.run(script)
    end
  end


  describe "tokens" do
    before(:each) do
      @sliced_4_ways = PizzaEaters::Interpreter.new(@pizza)
    end

    describe "rand" do
      it "should push a random number in [0,1] to each stack" do
        script = "rand"
        Random.should_receive(:rand).exactly(4).times.and_return(0,0)
        @sliced_4_ways.run(script)
        @sliced_4_ways.stacks.each {|s| s.length.should == 1}
        @sliced_4_ways.stacks.each {|s| (0.0..1.0).should include(s[-1])}
      end
    end

    describe "numbers" do
      it "should push the indicated integer to each stack as a float" do
        script = "0 11121 -13"
        @sliced_4_ways.run(script)
        @sliced_4_ways.stacks.each {|s| s.length.should == 3}
        @sliced_4_ways.stacks.each {|s| s.should == [0.0, 11121.0, -13.0]}
      end

      it "should push the indicated float to each stack" do
        script = "0.0 123.456 -765.432"
        @sliced_4_ways.run(script)
        @sliced_4_ways.stacks.each {|s| s.length.should == 3}
        @sliced_4_ways.stacks.each {|s| s.should == [0.0, 123.456, -765.432]}
      end
    end

    describe "weight" do
      it "should push the weight of the corresponding pizza slice" do
        @sliced_4_ways.run("weight")
        @sliced_4_ways.stacks.each {|s| s.length.should == 1}
        @sliced_4_ways.stacks.each_with_index {|s,idx| s.should == [@pizza.slices[idx]]}
      end

      it "should push floats" do
        @sliced_4_ways.run("weight")
        @sliced_4_ways.stacks.each {|s| s[-1].should be_a_kind_of(Float)}
      end
    end

    describe "total_weight" do
      it "should push the weight of the whole pizza" do
        @sliced_4_ways.run("total_weight")
        @sliced_4_ways.stacks.each {|s| s[-1].should == 10.0}
        @sliced_4_ways.stacks.each {|s| s[-1].should be_a_kind_of(Float)}
      end
    end

    describe "index" do
      it "should push the index of the corresponding slice (as a float)" do
        @sliced_4_ways.run("index")
        @sliced_4_ways.stacks.each {|s| s.length.should == 1}
        @sliced_4_ways.stacks.each_with_index {|s,idx| s[-1].should == idx.to_f}
      end
    end

    describe "slices" do
      it "should push the number of slices remaining in the whole pizza (as a float)" do
        @sliced_4_ways.run("slices")
        @sliced_4_ways.stacks.each {|s| s[-1].should == 4.0}
        @sliced_4_ways.stacks.each {|s| s[-1].should be_a_kind_of(Float)}
      end
    end

    describe "dup" do
      it "should push a copy of the top item on this stack (if any)" do
        @sliced_4_ways.run("3 dup")
        @sliced_4_ways.stacks.each {|s| s.should == [3.0, 3.0]}
        
        @sliced_4_ways.run("dup")
        @sliced_4_ways.stacks.each {|s| s.should == []}
      end
    end

    describe "swap" do
      it "should reverse the top 2 items on this stack (if present)" do
        @sliced_4_ways.run("3 2 1 swap")
        @sliced_4_ways.stacks.each {|s| s.should == [3.0, 1.0, 2.0]}
        
        @sliced_4_ways.run("swap")
        @sliced_4_ways.stacks.each {|s| s.should == []}

        @sliced_4_ways.run("2 swap")
        @sliced_4_ways.stacks.each {|s| s.should == [2.0]}
      end
    end

    describe "+" do
      it "should replace the top 2 values (if present) with their sum" do
        @sliced_4_ways.run("3 3 3 +")
        @sliced_4_ways.stacks.each {|s| s.should == [3.0, 6.0]}
        
        @sliced_4_ways.run("+")
        @sliced_4_ways.stacks.each {|s| s.should == []}

        @sliced_4_ways.run("2 +")
        @sliced_4_ways.stacks.each {|s| s.should == [2.0]}
      end
    end

    describe "-" do
      it "should replace the top 2 values (if present) with their difference" do
        @sliced_4_ways.run("3 2 1 -")
        @sliced_4_ways.stacks.each {|s| s.should == [3.0, 1.0]}
        
        @sliced_4_ways.run("-")
        @sliced_4_ways.stacks.each {|s| s.should == []}

        @sliced_4_ways.run("2 -")
        @sliced_4_ways.stacks.each {|s| s.should == [2.0]}
      end
    end

    describe "*" do
      it "should replace the top 2 values (if present) with their product" do
        @sliced_4_ways.run("3 33 333 *")
        @sliced_4_ways.stacks.each {|s| s.should == [3.0, 10989.0]}
        
        @sliced_4_ways.run("*")
        @sliced_4_ways.stacks.each {|s| s.should == []}

        @sliced_4_ways.run("2 *")
        @sliced_4_ways.stacks.each {|s| s.should == [2.0]}
      end
    end

    describe "/" do
      it "should replace the top 2 values (if present) with their quotient" do
        @sliced_4_ways.run("3 1 2 /")
        @sliced_4_ways.stacks.each {|s| s.should == [3.0, 0.5]}
        
        @sliced_4_ways.run("/")
        @sliced_4_ways.stacks.each {|s| s.should == []}

        @sliced_4_ways.run("2 /")
        @sliced_4_ways.stacks.each {|s| s.should == [2.0]}
      end

      it "should push 1.0 if the divisor is 0.0" do
        @sliced_4_ways.run("3 1 0 /")
        @sliced_4_ways.stacks.each {|s| s.should == [3.0, 1.0]}
      end
    end

    describe "left" do
      it "should push a copy of the topmost item on the stack to the 'left'" do
        @sliced_4_ways.run("index left")
        @pizza.should be_whole
        @sliced_4_ways.stacks.each_with_index {|s,idx| s[-1].should == (idx.to_f - 1.0) % 4.0}
      end

      it "should ignore nil items" do
        @sliced_4_ways.run("left")
        @sliced_4_ways.stacks.each {|s| s.length.should == 0}
      end

      it "should treat the pizza as circular if it's whole, or linear otherwise" do
        @sliced_4_ways.run("index left")
        @sliced_4_ways.stacks[0][-1].should == 3.0 # it wraps around the circle
        
        @pizza.eat_first_slice(2)
        @pizza.slices.should == [4,1,2]
        @sliced_4_ways.run("index left")
        @sliced_4_ways.stacks.should == [[0.0], [1.0, 0.0], [2.0, 1.0]]
      end
    end

    describe "right" do
      it "should push a copy of the topmost item on the stack to the 'right'" do
        @sliced_4_ways.run("index right")
        @sliced_4_ways.stacks.each_with_index {|s,idx| s[-1].should == (idx.to_f + 1.0) % 4.0}
      end

      it "should ignore nil items" do
        @sliced_4_ways.run("right")
        @sliced_4_ways.stacks.each {|s| s.length.should == 0}
      end

      it "should treat the pizza as circular if it's whole, or linear otherwise" do
        @sliced_4_ways.run("index right")
        @sliced_4_ways.stacks[3][-1].should == 0.0 # it wraps around the circle
        
        @pizza.eat_first_slice(2)
        @pizza.slices.should == [4,1,2]
        @sliced_4_ways.run("index right")
        @sliced_4_ways.stacks.should == [[0.0, 1.0], [1.0, 2.0], [2.0]]
      end
    end

    describe "depth" do
      it "should push the number of items currently on the stack" do
        @pizza.eat_first_slice(2)
        @sliced_4_ways.run("1 left left depth")
        @sliced_4_ways.stacks.should ==
          [[1.0, 1.0], [1.0, 1.0, 1.0, 3.0], [1.0, 1.0, 1.0, 3.0]]
      end
    end

    describe "pop" do
      it "should throw away the topmost item from the stack" do
        @sliced_4_ways.run("1 2 pop")
        @sliced_4_ways.stacks.should == [[1.0], [1.0], [1.0], [1.0]]
      end
    end

    describe "<" do
      it "should push 1.0 if the top stack item is bigger than the second one" do
        @sliced_4_ways.run("index 2 <")
        @sliced_4_ways.stacks.should == [[1.0], [1.0], [0.0], [0.0]]
      end
    end

    describe ">" do
      it "should push 1.0 if the top stack item is smaller than the second one" do
        @sliced_4_ways.run("index 2 >")
        @sliced_4_ways.stacks.should == [[0.0], [0.0], [0.0], [1.0]]
      end
    end

    describe "==" do
      it "should push 1.0 if the top stack item is identical to the second one" do
        @sliced_4_ways.run("index 2 ==")
        @sliced_4_ways.stacks.should == [[0.0], [0.0], [1.0], [0.0]]
      end
    end

    describe "gibberish" do
      it "should ignore tokens it can't recognize" do
        @sliced_4_ways.run("xhahasllas")
        @sliced_4_ways.stacks.each {|s| s.should == []}
      end
    end
  end
end