module PizzaEaters
  class Player 
    attr_reader :first_choice
    attr_reader :second_choices


    def initialize(args={})
      @first_choice = args[first_choice] || "rand"
      @second_choices = args[second_choices] || "rand"
    end


    def choose_first_piece(pizza)
      scores = score_pizza(pizza)
      biggest_score = scores.max
      choices = (0...scores.length).select {|idx| scores[idx] == biggest_score}
      pizza.eat_first_slice(choices.sample)
    end

    
    def score_pizza(pizza)
      scores = pizza.slices.collect do |slice|
        score_as_first(pizza,slice)
      end
      scores
    end    


    def score_as_first(pizza,slice)
      Random.rand()
    end
  end


  class Pizza
    attr_accessor :slices
    attr_accessor :whole

    def initialize(size_array)
      @slices = size_array
      @whole = true
    end

    def whole?
      whole
    end

    def weight
      @slices.inject(0) {|sum,w| sum+w}
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
end