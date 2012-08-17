# Applying GP to Winkler's Pizza Eating Game

A recent [arXiv preprint entitled "How to eat 4/9 of a Pizza"](http://arxiv.org/abs/0812.2870) caught my eye. It's an interesting little answer to a challenge from game theory (and geometry, I suppose) posed by [Peter Winkler](http://www.math.dartmouth.edu/~pw/), who's a constant source of inspiration.

## Begin Eating Now

Suppose we have a circular pizza, already cut into wedge-shaped slices (from the center to the crust). These are *extremely* precise slices, and in fact they can have "0 width", or some small epsilon close enough to 0 to be entertaining.

There are two hungry players, Alice and Bob. Alice chooses a piece to eat first. Bob and Alice alternate eating pieces of pizza after that, until it's gone, but they must both *always* choose one of the two pieces adjacent to the growing gap.

The [arXiv preprint](http://arxiv.org/abs/0812.2870) describes a strategy by which Alice can eat at least 4/9 of the pizza, regardless of the slices or how smart Bob's strategy is. She may be able to eat more than 4/9, depending on the slices and Bob's mistakes. And of course she's only *guaranteed* to get that much if she's following a provably optimal strategy.

## Beging Evolving Now

See, I've been writing [this book](https://leanpub.com/pragmaticGP), and there are a number of little side-projects like this one that have come up, but probably won't make the cut for the final edit. The six large-scale projects I'm working on keep me busy enough, but at the same time I'm trying to polish and refine my "simplified" approach to GP project management.

So this is me thinking in code about that.