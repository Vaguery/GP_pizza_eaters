# Applying GP to Winkler's Pizza Eating Game

A recent [arXiv preprint entitled "How to eat 4/9 of a Pizza"](http://arxiv.org/abs/0812.2870) caught my eye. It's an interesting little answer to a challenge from game theory (and geometry, I suppose) posed by [Peter Winkler](http://www.math.dartmouth.edu/~pw/), who's a constant source of inspiration.

## Hungry, Hungry Alice & Bob

Suppose we have a circular pizza, already cut into wedge-shaped slices (from the center to the crust). These are *extremely* precise slices, and in fact they can have "0 width", or some small epsilon close enough to 0 to be entertaining.

There are two hungry players, Alice and Bob. Alice chooses a piece to eat first. Bob and Alice alternate eating pieces of pizza after that, until it's gone, but they must both *always* choose one of the two pieces adjacent to the growing gap.

The [arXiv preprint](http://arxiv.org/abs/0812.2870) describes a strategy by which Alice can eat at least 4/9 of the pizza, regardless of the slices or how smart Bob's strategy is. She may be able to eat more than 4/9, depending on the slices and Bob's mistakes. And of course she's only *guaranteed* to get that much if she's following a provably optimal strategy.

## Agents: Represent

See, I've been writing [this book](https://leanpub.com/pragmaticGP), and there are a number of little side-projects like this one that have come up, but probably won't make the cut for the final edit. The six large-scale projects I'm working on keep me busy enough, but at the same time I'm trying to polish and refine my "simplified" approach to GP project management.

So this is me thinking in Ruby about one of those little side-projects.

I've also recently been watching [Lee Spector's explanations of Tag Space Machines](https://hampedia.org/wiki/File:Tsm.pdf) unfold. Tag Space Machines (TSMs) are a representation scheme for GP languages he's implemented in his lab's work. I think I may work with TSMs here.

## Pizza

The pizza is modeled as an Array of "slice weights". An uneaten pizza is considered to be circular, and the first player ("Alice") can eat any piece she wants. Eating the first piece "unfolds" the pizza, restructuring the array so that the start and end values are the pieces on the "right" and "left" of the gap. After that, players can only choose to eat one of the two end pieces.

In other words, the player agents have only three actions (besides "planning"): `eat_first_piece`, `eat_left_piece` and `eat_right_piece`. And they don't even get free choice among those three, since the first is mutually exclusive with the last two.

## How to think about eating pizza

The big design question here is, how do players *think* about the pizza? 

A slightly more traditional approach might have them handling arrays and iterating and stuff. But having modeled game-play before, I know there's also more distributed (if less intuitive) approach I'm wondering about here: since there are so few choices in the game, what if a "thinking" or "strategy" were a *scalar field* calculated locally for each of the pizza slices individually, and which slice is chosen by a given agent was determined by the highest-scoring pizza slice according to that agent's slice field algorithm?

In other words, suppose Alice has `eat_first_slice` field definition that is a function applied to each element of the pizza slice array (treating it as circular). The arguments are the weight of "this" slice, and weights and distances of slices to the relative left and right of "this" slice, and the number of slices overall. Maybe her `eat_first_slice` field is the weight of a slice plus the average weight of its six neighbors on either side.

Alice's first turn begins with her calculation of this field for the given pizza, and then she selects the highest-scoring slice. If Bob and Alice then have a (possibly different) function for scoring the slices of the non-circular pizza, the same dynamics can apply to their subsequent choices of `left_slice` over `right_slice`. In cases of ties, we pick at random.

Might this approach work? I have no idea. It *feels* as though it has some flexibility. We'll see.

## Trying it and see

Further updates on the progress of the project will be posted at my [Pragmatic GP](http://www.vagueinnovation.com/pragmatic_gp/) blog. Code will be posted here, of course.