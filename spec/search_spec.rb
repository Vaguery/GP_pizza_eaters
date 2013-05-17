require 'spec_helper'

describe "experiment workstations" do
  describe "Create random player" do
    it "should produce a new random Player with two scripts of specified length"
  end

  describe "Scoring Players" do
    it "should take two Players and a Pizza as arguments"
    it "should run a lot of games between the players"
    it "should record data on what pizza and what scores were obtained in the Player logs"
    # should pizzas also have logs?
    it "should work for odd or even number of pizza slices"
    it "should record the final amount eaten for each trial"
    it "should work for 0-slice pizza, recording scores of 0.0 for each player"
    it "should record the total number of unresolved choices each player faces in a game"
  end

  describe "Mutating Players" do
    it "should take in a Player and return a new variant with _p_ tokens replaced at random"
  end

  describe "Crossover" do
    it "should take in two Players and return one new variant with crossover applied to the scripts"
  end

  describe "Selection" do
    it "should take in a collection of Players and sort them based on their logs"
    it "should be able to sort based on average score over all trials"
    it "should be able to sort based on average uncertainity over all trials"
    it "should be able to produce a nondominated subset"
    it "should be able to produce a most-dominated subset"
  end
end

