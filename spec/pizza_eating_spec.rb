require 'spec_helper'


describe "players" do
  describe "initialization" do
    describe "first piece function" do
      it "should have a script to grade the first piece it eats" do
        PizzaEaters::Player.new.first_script.should_not be_nil
      end

      it "should default to an empty script" do
        PizzaEaters::Player.new.first_script.should == ""
      end
    end

    describe "main script" do
      it "should have a script to grade the later pieces it eats" do
        PizzaEaters::Player.new.main_script.should_not be_nil
      end

      it "should default an empty script" do
        PizzaEaters::Player.new.main_script.should == ""
      end
    end

    it "should have a weight_eaten, initialized to 0.0" do
      PizzaEaters::Player.new.weight_eaten.should == 0
    end
  end


  describe "eating slices" do
    before(:each) do
      @pizza = PizzaEaters::Pizza.new([0,1,2,3,4,5])
      @andi = PizzaEaters::Player.new
    end

    it "should create a new Interpreter" do
      expected_result = PizzaEaters::Interpreter.new(@pizza)
      PizzaEaters::Interpreter.should_receive(:new).with(@pizza).and_return(expected_result)
      @andi.eat_tastiest_piece(@pizza)
    end

    it "should run the first_script if the pizza is whole" do
      @andi.eat_tastiest_piece(@pizza)
    end

    it "should pick a slice from a whole pizza based on the highest score it determines" do
      @andi.stub(:tastiest_piece).and_return(2)
      @andi.eat_tastiest_piece(@pizza)
      @pizza.should_not be_whole
      @pizza.slices.should == [3,4,5,0,1]
    end

    it "should never produce nil values as scores" do
      @andi.first_script = ""
      @andi.main_script = ""
      @andi.slice_scores(@pizza).should_not include(nil)
    end

    it "should only pick the left or right slice from a partially eaten pizza" do
      @pizza.eat_first_slice(2)
      # @pizza.slices.should == [3,4,5,0,1]

      @andi.main_script = "weight"
      @andi.eat_tastiest_piece(@pizza)
      @pizza.slices.should == [4,5,0,1] # ate the highest-scoring end one, not the highest overall

      @andi.main_script = "0.0 weight - "
      @andi.eat_tastiest_piece(@pizza)
      @pizza.slices.should == [4,5,0] # ate the highest-scoring end one, not the highest overall
    end

    it "should shrink a whole pizza as expected" do
      p = PizzaEaters::Pizza.new( [0,1,2,3] )
      @andi.eat_tastiest_piece( p )
      p.slices.length.should == 3
    end

    it "should shrink a partially eaten pizza as expected" do
      p = PizzaEaters::Pizza.new( [0,1,2,3,4,5] )
      p.eat_first_slice(2)
      p.slices.should == [3,4,5,0,1]

      @andi.stub(:tastiest_piece).and_return(0)
      @andi.eat_tastiest_piece(p)
      p.slices.should == [4,5,0,1]

      @andi.stub(:tastiest_piece).and_return(3)
      @andi.eat_tastiest_piece(p)
      p.slices.should == [4,5,0]
    end

    it "should gain weight equal to the eaten pieces" do
      p = PizzaEaters::Pizza.new( [0,1,2,3,4,5] )
      @andi.first_script = "weight"
      @andi.eat_tastiest_piece(p)
      p.slices.should == [0,1,2,3,4]
      @andi.weight_eaten.should == 5

      @andi.main_script = "weight"
      @andi.eat_tastiest_piece(p)
      p.slices.should == [0,1,2,3]
      @andi.weight_eaten.should == 9

      @andi.main_script = "0 weight -"
      @andi.eat_tastiest_piece(p)
      p.slices.should == [1,2,3]
      @andi.weight_eaten.should == 9
    end
  end


  describe "running scripts" do
    before(:each) do
      @pizza = PizzaEaters::Pizza.new([0,1,2,3,4])
      @abby = PizzaEaters::Player.new(first_script:"weight",main_script:"0 weight -")
    end

    it "should execute the first_script when the pizza is whole" do
      @abby.eat_tastiest_piece(@pizza)
      @pizza.slices.should == [0,1,2,3]
    end

    it "should execute the main_script when the pizza is not whole" do
      @pizza.eat_first_slice(2)
      @pizza.slices.should == [3, 4, 0, 1]
      @pizza.should_not be_whole
      @abby.eat_tastiest_piece(@pizza)
      @pizza.slices.should == [3,4,0]
    end
  end


  describe "eating a one-slice pizza" do
    it "should work OK" do
      p = PizzaEaters::Pizza.new([333])
      a = PizzaEaters::Player.new
      a.eat_tastiest_piece(p)
      p.slices.should == []
      a.weight_eaten.should == 333
    end
  end


  describe "eating an empty pizza" do
    it "should raise an ArgumentError if attempted" do
      p = PizzaEaters::Pizza.new([])
      a = PizzaEaters::Player.new
      lambda{ a.eat_tastiest_piece(p) }.should raise_error(ArgumentError)
    end
  end
end