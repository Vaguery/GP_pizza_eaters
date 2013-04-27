require_relative '../lib/pizza'

@tokens = ["rand", "weight", "total_weight",
  "index", "slices", "k",
  "dup", "swap",
  "+", "-", "*", "/",
  "left", "right"]

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


20.times do |p|
  the_pizza = PizzaEaters::Pizza.new( 20.times.collect {Random.rand(20)})
  total_weight = the_pizza.weight
  alice.weight_eaten = 0.0
  bob.weight_eaten = 0.0

  setup = [alice,bob].shuffle

  puts "\npizza: #{the_pizza.slices.inspect}"
  until the_pizza.slices.empty? do
    setup[0].eat_tastiest_piece(the_pizza)
    setup[1].eat_tastiest_piece(the_pizza)

    puts "alice: #{alice.weight_eaten / total_weight} bob:#{bob.weight_eaten / total_weight}"
  end
end