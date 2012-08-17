
Given /^I have a new pizza$/ do
  @pizza = Pizza.new
end

Given /^a list of slice sizes (\[.+\])$/ do |slices|
  @slice_list = eval(slices)
end

Given /^the pizza is sliced into (\[.+\])$/ do |slices|
  @pizza.slice eval(slices)
end

Given /^no pieces have been eaten$/ do
  @pizza.whole = true
end



When /^I slice the pizza$/ do
  @pizza.slice(@slice_list)
end

When /^I take out piece (\d+)$/ do |which|
  @pizza.eat_first_slice(which.to_i-1)
end



Then /^there should be (\d+) slices$/ do |count|
  @pizza.slices.length.should == count.to_i
end

Then /^the pizza should weigh (\d+)$/ do |weight|
  @pizza.weight.should == weight.to_f
end

Then /^the pizza should be whole$/ do
  @pizza.should be_whole
end

Then /^the pizza should not be whole$/ do
  @pizza.should_not be_whole
end

Then /^the left slice should weigh (\d+)$/ do |weight|
  @pizza.left_slice.should == weight.to_f
end

Then /^the right slice should weigh (\d+)$/ do |weight|
  @pizza.right_slice.should == weight.to_f
end