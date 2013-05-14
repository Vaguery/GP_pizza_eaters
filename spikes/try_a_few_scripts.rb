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

alice = PizzaEaters::Player.new(
  first_script:random_script(10),
  main_script:random_script(10))

bob = PizzaEaters::Player.new(
  first_script:random_script(10),
  main_script:random_script(10))

puts "# alice: #{alice.inspect}"
puts "# bob: #{bob.inspect}"
puts "pizza,trial,alice,bob"


20.times do |pizza|

  the_pizza = PizzaEaters::Pizza.new( 20.times.collect {Random.rand(20)})
  total_weight = the_pizza.weight
  puts "# #{the_pizza.slices.inspect}"

  1000.times do |trial|
    reset_pizza = the_pizza.clone
    alice.weight_eaten = 0.0
    bob.weight_eaten = 0.0

    setup = [alice,bob].shuffle # shuffle for more variety

    until reset_pizza.slices.empty? do
      setup[0].eat_tastiest_piece(reset_pizza)
      setup[1].eat_tastiest_piece(reset_pizza)
    end

    puts "#{pizza},#{trial},#{alice.weight_eaten / total_weight},#{bob.weight_eaten / total_weight}"
  end
end