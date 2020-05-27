# Tuning-parameters-using-10-fold-CV
In this problem, you will consider choosing the tuning parameters for both ridge regression and the lasso, using 10-fold cross-validation.


## Objective:
We begin with a true signal bstar. Although this is stored as a vector of length p = 2500, bstar really represents an image of dimension 50X50. You can plot it by calling:

**plot.image( bs t a r ) .**

This image is truly sparse, in the sense that 2084 of its pixels have a value of 0, while 416 pixels have a value of 1. You can think of this image as a toy version of an MRI image that we are interested in collecting.

Suppose that, because of the nature of the machine that collects the MRI image, it takes a long time to measure each pixel value individually, but it's faster to measure a linear combination of pixel values. We measure n = 1300 linear combinations, with the weights
in the linear combination being random, in fact, independently distributed as N(0; 1). These measurements are given by the entries of the vector: **X % * % bs t a r** in our R code. 

Because the machine is not perfect, we don't get to observe this directly, but we see a noisy version of this. Hence, in terms of our R code, we observe
**y = X % * % bs t a r + rnorm(n , sd=5).**

Now the question is: can we model y as a linear combination of the columns of X to recover some coecient vector that is close to bstar? Roughly speaking, the answer is yes. Key points here: although the number of measurements n = 1300 is smaller than the dimension p = 2500, the true vector bstar is sparse, and the weights in a linear combination are i.i.d normal. This is the idea behind the eld of compressed sensing.


## TODO:
The list of items we need to perform is given with the Homework3 pdf inside the 'Guidelines' folder.


## Analysis:
It is provided in detail in the 'Analysis folder. The corresponding code is shared inside the 'Code' folder.
