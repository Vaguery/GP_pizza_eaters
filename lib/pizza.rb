module PizzaEaters
  class Interpreter
    attr_accessor :stacks
    attr_reader :pizza


    def initialize(pizza)
      @pizza = pizza
    end


    def run(script)
      @stacks = pizza.slices.length.times.collect {Array.new}
      tokens = script.strip.split
      tokens.each do |t|
        interpret_token(t)
      end
    end


    def interpret_token(token)
      case token
      when "rand"
        stacks.each {|s| s.push Random.rand()}
      when "weight"
        stacks.each_with_index {|s,idx| s.push @pizza.slices[idx].to_f}
      when "total_weight"
        wt = @pizza.weight
        stacks.each {|s| s.push wt.to_f}
      when "index"
        stacks.each_with_index {|s,idx| s.push idx.to_f}
      when "slices"
        stacks.each {|s| s.push @pizza.slices.length.to_f}
      when /-?\d+.?\d*/
        stacks.each {|s| s.push token.to_f}
      when "dup"
        stacks.each {|s| s.push(s[-1]) unless s.empty?}
      when "swap"
        stacks.each {|s| s[-1],s[-2] = s[-2],s[-1] unless s.length < 2}
      when "depth"
        stacks.each {|s| s.push s.length.to_f}
      when "pop"
        stacks.each {|s| s.pop}
      when "+"
        stacks.each {|s| s.push(s.pop + s.pop) unless s.length < 2}
      when "-"
        stacks.each {|s| s.push(-s.pop + s.pop) unless s.length < 2}
      when "*"
        stacks.each {|s| s.push(s.pop * s.pop) unless s.length < 2}
      when "/"
        stacks.each do |s| 
          unless s.length < 2
            a,b = s.pop(2)
            s.push (b == 0.0 ? 1.0 : a/b)
          end
        end
      when "left"
        top_left = peek(-1)
        stacks.each_with_index { |s,idx| s.push top_left[idx] unless top_left[idx].nil? }
      when "right"
        top_right = peek(+1)
        stacks.each_with_index { |s,idx| s.push top_right[idx] unless top_right[idx].nil? }
      when "<"
        stacks.each {|s| s.push(s.pop > s.pop ? 1.0 : 0.0) unless s.length < 2}
      when ">"
        stacks.each {|s| s.push(s.pop < s.pop ? 1.0 : 0.0) unless s.length < 2}
      when "=="
        stacks.each {|s| s.push(s.pop == s.pop ? 1.0 : 0.0) unless s.length < 2}
      else
        # do nothing
      end
    end


    def peek(offset)
      indices = (0...@pizza.slices.length)
      indices.collect do |idx|
        if @pizza.whole?
          where = (idx + offset) % @pizza.slices.length
          @stacks[where][-1]
        else
          where = idx + offset
          indices.include?(where) ? @stacks[where][-1] : nil
        end
      end
    end
  end



  class Player 
    attr_accessor :first_script
    attr_accessor :main_script
    attr_accessor :weight_eaten


    def initialize(args={})
      @first_script = args[:first_script] || ""
      @main_script = args[:main_script] || ""
      @weight_eaten = 0.0
    end


    def eat_tastiest_piece(pizza)
      raise(ArgumentError.new "This pizza is empty!?") if pizza.slices.empty?
      selection = tastiest_piece(pizza)
      eat_that_slice(pizza,selection)
    end


    def eat_that_slice(pizza,index)
      size_of_slice = pizza.eat_slice(index)
      @weight_eaten += size_of_slice
    end


    def slice_scores(pizza)
      evaluator = Interpreter.new(pizza)
      pizza.whole? ? evaluator.run(@first_script) : evaluator.run(@main_script)
      return evaluator.stacks.collect {|s| s[-1] || 0.0}
    end


    def tastiest_piece(pizza)
      scores = slice_scores(pizza)
      possibilities = pizza.whole? ? (0...scores.length) : [0,scores.length-1]
      highest_score = pizza.whole? ? scores.max : [scores[0],scores[-1]].max
      indices_of_winners = possibilities.select {|idx| scores[idx] == highest_score}
      return indices_of_winners.sample
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


    def eat_slice(which)
      return case 
      when self.whole?
        eat_first_slice(which)
      when which == 0
        eat_left_slice
      when which == @slices.length - 1
        eat_right_slice
      else
        raise ArgumentError.new "Impolite pizza eating: cannot take slice ##{which+1} out of #{@slices.length}"
      end
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