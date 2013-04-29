require_relative '../lib/pizza'

@tokens = ["weight", "total_weight",
  "index", "slices", "k",
  "dup", "swap",
  "+", "-", "*", "/",
  "pop","depth",
  "left", "right",
  "<", ">", "=="]

def random_script(length)
  length.times.inject("") do |script,token|
    t = @tokens.sample
    t = (Random.rand(20) - 10.0) if t == "k"
    "#{script} #{t}"
  end
end


def nondominated(batch)
  winners = []
  batch.each do |answer|
    winner = batch.inject(true) do |anded, other_answer| 
      anded && (!a_dominated_by_b?(answer,other_answer))
    end
    winners << answer if winner
  end
  return winners
end


def a_dominated_by_b?(answer_a, answer_b)
  could_be_identical = true
  a_vector = [answer_a.avg_weight, answer_a.weight_range]
  b_vector = [answer_b.avg_weight, answer_b.weight_range]

  a_vector.each_with_index do |my_score,idx|
    other_score = b_vector[idx]
    return false if my_score < other_score
    if could_be_identical
      could_be_identical &&= (my_score == other_score)
    end
  end
  
  return !could_be_identical
end


def a_dominated_by_b_with_length?(answer_a, answer_b)
  could_be_identical = true
  a_vector = [answer_a.avg_weight, answer_a.weight_range, answer_a.player.first_script.length + answer_a.player.main_script.length]
  b_vector = [answer_b.avg_weight, answer_b.weight_range, answer_b.player.first_script.length + answer_b.player.main_script.length]

  a_vector.each_with_index do |my_score,idx|
    other_score = b_vector[idx]
    return false if my_score < other_score
    if could_be_identical
      could_be_identical &&= (my_score == other_score)
    end
  end
  
  return !could_be_identical
end


Struct.new("Answer", :player, :avg_weight, :weight_range)


@alice = Struct::Answer.new(
  PizzaEaters::Player.new(
    first_script:random_script(20),
    main_script:random_script(20)),
  0.0,
  0.0)


@bob = Struct::Answer.new(
  PizzaEaters::Player.new(
    first_script:"index",
    main_script:"index"),
  0.0,
  0.0)

puts "# bob: #{@bob.inspect}\n"


def average(array)
  total = array.inject(0) {|sum,v| sum + v}
  return total/array.length
end


def range(array)
  (array.max - array.min)
end


def mutate(script, p=0.05)
  words = script.split
  mutant = words.collect {|w| Random.rand() < p ? Random.rand(words.length) : w}
  mutant = mutant.collect {|w| w == "k" ? Random.rand(20)-10.0 : w}
  return mutant.join(" ")
end


def crossover(script_1, script_2)
  t1 = script_1.split
  t2 = script_2.split
  cut1 = Random.rand(t1.length)
  cut2 = Random.rand(t2.length)
  baby = t1[0..cut1] + t2[cut2..-1]
  return baby.join(" ")
end


def score_answer(answer)
  scores = []
  100.times do |trial|
    slices = 20.times.collect {Random.rand(20)}
    pizza = PizzaEaters::Pizza.new(slices)
    total_weight = pizza.weight
    answer.player.weight_eaten = 0.0

    until pizza.slices.empty? do
      answer.player.eat_tastiest_piece(pizza)
      @bob.player.eat_tastiest_piece(pizza)
    end
    uneaten = 1.0 - (answer.player.weight_eaten / total_weight.to_f)
    scores << uneaten
  end
  answer.avg_weight = average(scores)
  answer.weight_range = range(scores)
end


score_answer(@alice)
best_so_far = 10.times.collect do |b|
  baby = Struct::Answer.new(
  PizzaEaters::Player.new(
    first_script:random_script(20),
    main_script:random_script(20)),
  0.0,
  0.0)
  score_answer(baby)
  puts "0,#{b},#{baby.avg_weight},#{baby.weight_range},#{baby.player.first_script.length + baby.player.main_script.length},#{baby.player.first_script},#{baby.player.main_script}"
  baby
end


10000.times do |step|
  mom = best_so_far.sample
  dad = best_so_far.sample
  baby = Struct::Answer.new(
    PizzaEaters::Player.new(
      first_script:mutate(crossover(mom.player.first_script,dad.player.first_script)),
      main_script:mutate(crossover(mom.player.main_script,dad.player.main_script))),
    0.0,
    0.0)
  score_answer(baby)

  all_of_them = best_so_far << baby
  best_so_far = nondominated(all_of_them)

  puts "# #{step} #{best_so_far.length}"
  best_so_far.each_with_index do |w,idx|
    puts "#{step},#{idx},#{w.avg_weight},#{w.weight_range},#{w.player.first_script.length + w.player.main_script.length},#{w.player.first_script},#{w.player.main_script}"
  end
  puts "#{step},-1,#{baby.avg_weight},#{baby.weight_range},#{baby.player.first_script.length + baby.player.main_script.length},#{baby.player.first_script},#{baby.player.main_script}"
end