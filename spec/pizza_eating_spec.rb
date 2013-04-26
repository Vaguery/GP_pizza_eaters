require 'spec_helper'


describe "players" do
  describe "eating pizza" do
    describe "first piece function" do
      it "should have a script for the first piece" do
        PizzaEaters::Player.new.first_choice.should_not be_nil
      end

      it "should default to 'rand'" do
        PizzaEaters::Player.new.first_choice.should == "rand"
      end
    end

    describe "more pieces function" do
      it "should have a script for the later pieces" do
        PizzaEaters::Player.new.second_choices.should_not be_nil
      end

      it "should default to 'rand'" do
        PizzaEaters::Player.new.second_choices.should == "rand"
      end

    end

    describe "eating the first slice" do
      before(:each) do
        @simple = PizzaEaters::Pizza.new([1,2,3,4,5])
      end

      it "should score every slice in the pizza" do
        andi = PizzaEaters::Player.new
        andi.should_receive(:score_pizza).with(@simple).and_return([1,2,3,4,5])
        andi.choose_first_piece(@simple)
      end

      it "should run its first_choice script for every slice"

      it "should pick the first slice based on the highest score it determines" do
        andi = PizzaEaters::Player.new
        andi.stub(:score_pizza).and_return([1,2,5,4,3])
        andi.choose_first_piece(@simple)
        @simple.should_not be_whole
        @simple.slices.should == [4,5,1,2]
      end
    end


    describe "eating subsequent slices" do
      before(:each) do
        @simple = PizzaEaters::Pizza.new([1,2,3,4,5])
      end

      it "should score the left and right slices"

      it "should run its second_choices script for each of the two end slices"

      it "should pick the end slice with the highest second_choices score"
    end


    describe "eating the last slice" do
      
    end


    describe "eating a one-slice pizza" do
      
    end

    describe "managing and recording scores" do
      
    end
  end
end