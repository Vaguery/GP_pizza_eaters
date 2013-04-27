require 'spec_helper'


describe "players" do
  describe "initialization" do
    describe "first piece function" do
      it "should have a script for the first piece" do
        PizzaEaters::Player.new.first_script.should_not be_nil
      end

      it "should default to an empty script" do
        PizzaEaters::Player.new.first_script.should == ""
      end
    end

    describe "more pieces function" do
      it "should have a script for the later pieces" do
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

    it "should score the pizza slices" do
      @andi = PizzaEaters::Player.new
      @andi.should_receive(:score_pizza).with(@pizza).and_return([0,1,2,3,4,5])
      @andi.eat_tastiest_piece(@pizza)
    end

    it "should call score_slice for each slice" do
      @andi.should_receive(:score_slice).with(@pizza,kind_of(Numeric)).exactly(6).times
      @andi.eat_tastiest_piece(@pizza)
    end

    it "should pick a slice from a whole pizza based on the highest score it determines" do
      @andi.stub(:score_pizza).and_return([0,0,4,0,0,0])
      @andi.eat_tastiest_piece(@pizza)
      @pizza.should_not be_whole
      @pizza.slices.should == [3,4,5,0,1]
    end

    it "should only pick the left or right slice from a partially eaten pizza" do
      @pizza.eat_first_slice(2)
      @pizza.should_not be_whole
      @pizza.slices.should == [3,4,5,0,1]

      @andi.stub(:score_pizza).and_return([9,0,0,0,1])
      @andi.eat_tastiest_piece(@pizza)
      @pizza.slices.should == [4,5,0,1]
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

      @andi.stub(:score_pizza).and_return([0,0,0,0,9])
      @andi.eat_tastiest_piece(p)
      p.slices.should == [3,4,5,0]

      @andi.stub(:score_pizza).and_return([9,0,0,0])
      @andi.eat_tastiest_piece(p)
      p.slices.should == [4,5,0]
    end

    it "should gain weight equal to the eaten pieces" do
      p = PizzaEaters::Pizza.new( [0,1,2,3,4,5] )
      @andi.stub(:score_pizza).and_return([0,1,2,3,4,5])
      @andi.eat_tastiest_piece(p)
      p.slices.should == [0,1,2,3,4]
      @andi.weight_eaten.should == 5

      @andi.stub(:score_pizza).and_return([0,0,0,0,1])
      @andi.eat_tastiest_piece(p)
      p.slices.should == [0,1,2,3]
      @andi.weight_eaten.should == 9

      @andi.stub(:score_pizza).and_return([1,0,0,0])
      @andi.eat_tastiest_piece(p)
      p.slices.should == [1,2,3]
      @andi.weight_eaten.should == 9
    end
  end


  describe "running scripts" do
    before(:each) do
      @pizza = PizzaEaters::Pizza.new([0,1,2,3,4])
      @abby = PizzaEaters::Player.new(first_script:"rand",main_script:"")
    end

    it "should clear the stack" do
      @abby.should_receive(:reset_stack)
      @abby.score_slice(@pizza,2)
    end

    it "should execute the first_script when the pizza is whole" do
      @abby.first_script.should_receive(:split).and_return(["rand"])
      @abby.main_script.should_not_receive(:split)
      @abby.score_slice(@pizza,2)
    end

    it "should execute the main_script when the pizza is not whole" do
      @pizza.eat_first_slice(3)
      @abby.first_script.should_not_receive(:split)
      @abby.main_script.should_receive(:split).and_return([""])
      @abby.score_slice(@pizza,2)
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
end