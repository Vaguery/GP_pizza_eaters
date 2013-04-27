module PizzaEaters
  class Player 
    attr_reader :first_script
    attr_reader :main_script
    attr_accessor :stack
    attr_accessor :weight_eaten


    def initialize(args={})
      @first_script = args[:first_script] || ""
      @main_script = args[:main_script] || ""
      @stack=[]
      @weight_eaten = 0
    end


    def eat_tastiest_piece(pizza)
      raise(ArgumentError.new "This pizza is empty!?") if pizza.slices.empty?
      selection = tastiest_piece(pizza)
      eat_that_slice(pizza,selection)
    end


    def eat_that_slice(pizza,index)
      size_of_slice = 
        case
        when pizza.whole?
          pizza.eat_first_slice(index)
        when index == 0
          pizza.eat_left_slice
        else
          pizza.eat_right_slice
        end
      @weight_eaten += size_of_slice
    end


    def tastiest_piece(pizza)
      scores = score_pizza(pizza)
      possibilities = pizza.whole? ? (0...scores.length) : [0,-1]
      highest_score = pizza.whole? ? scores.max : [scores[0],scores[-1]].max
      indices_of_winners = possibilities.select {|idx| scores[idx] == highest_score}
      return indices_of_winners.sample
    end

    
    def score_pizza(pizza)
      scores = pizza.slices.collect do |slice|
        score_slice(pizza,slice)
      end
      scores
    end    


    def reset_stack
      @stack=[]
    end


    def run_script(pizza,slice)
      reset_stack
      tokens = pizza.whole? ? @first_script.split : @main_script.split
      tokens.each do |token|
        case token
        when "rand"
          @stack.push Random.rand()  
        else
          # ignore it
        end
      end
    end


    def score_slice(pizza,slice)
      run_script(pizza,slice)
      return @stack[-1]
    end
  end



  class Pizza
    attr_accessor :slices
    attr_accessor :whole

    def initialize(size_array=[1])
      @slices = size_array
      @whole = true
    end

    def whole?
      whole
    end

    def eaten_all_up?
      @slices.empty?
    end

    def weight
      @slices.inject(0) {|sum,w| sum+w}
    end

    def eat_first_slice(which)
      eaten = @slices[which]
      open_circle = @slices[which+1..-1] + @slices[0...which]
      @slices = open_circle
      @whole = false
      return eaten
    end

    def eat_left_slice
      @slices.shift
    end

    def eat_right_slice
      @slices.pop
    end
  end
end