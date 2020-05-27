# Install the glmnet package if you haven't done so
# install.packages("glmnet")

library(glmnet)
source("plotfuns.R")
load("bstar.Rdata")

plot.image(bstar)

p = length(bstar)
set.seed(0)
n = 1300
X = matrix(rnorm(n*p),nrow=n)
y = X%*%bstar + rnorm(n,sd=5)

K = 10
d = ceiling(n/K)
set.seed(0)
i.mix = sample(1:n)
# i.mix

# Tuning parameter values for lasso, and ridge regression
lam.las = c(seq(1e-3,0.1,length=100),seq(0.12,2.5,length=100)) 
lam.rid = lam.las*1000

nlam = length(lam.las)
# These two matrices store the prediction errors for each
# observation (along the rows), when we fit the model using
# each value of the tuning parameter (along the columns)
e.rid = matrix(0,n,nlam)
e.las = matrix(0,n,nlam)

for (k in 1:K) {
  cat("Fold",k,"\n")
  
  folds=(1+(k-1)*d):(k*d);
  i.tr=i.mix[-folds]
  i.val=i.mix[folds]

  X.tr = X[i.tr,]   # training predictors
  y.tr = y[i.tr]    # training responses
  X.val = X[i.val,] # validation predictors
  y.val = y[i.val]  # validation responses
  
  # TODO
  # Now use the function glmnet on the training data to get the 
  # ridge regression solutions at all tuning parameter values in
  # lam.rid, and the lasso solutions at all tuning parameter 
  # values in lam.las
  a.rid = glmnet(X.tr, y.tr, alpha = 0, lambda = lam.rid) # for the ridge regression solutions, use alpha=0
  a.las = glmnet(X.tr, y.tr, alpha = 1, lambda = lam.las) # for the lasso solutions, use alpha=1
  
  
  # Here we're actually going to reverse the column order of the
  # a.rid$beta and a.las$beta matrices, because we want their columns
  # to correspond to increasing lambda values (glmnet's default makes
  # it so that these are actually in decreasing lambda order), i.e.,
  # in the same order as our lam.rid and lam.las vectors
  rid.beta = as.matrix(a.rid$beta[,nlam:1])
  las.beta = as.matrix(a.las$beta[,nlam:1])
  
  yhat.rid = X.val%*%rid.beta
  yhat.las = X.val%*%las.beta
  
  e.rid[i.val,] = (yhat.rid-y.val)^2
  e.las[i.val,] = (yhat.las-y.val)^2
}

# TODO
# Here you need to compute: 
# -cv.rid, cv.las: vectors of length nlam, giving the cross-validation
#  errors for ridge regresssion and the lasso, across all values of the
#  tuning parameter
# -se.rid, se.las: vectors of length nlam, giving the standard errors
#  of the cross-validation estimates for ridge regression and the lasso, 
#  across all values of the tunining parameter

cv.rid = apply(e.rid, 2, mean)
cv.las = apply(e.las, 2, mean)
se.rid = apply(e.rid, 2,function (x) sd(x)/(n^0.5))
se.las = apply(e.las, 2,function (x) sd(x)/(n^0.5))

# Usual rule for choosing lambda
i1.rid = which.min(cv.rid)
i1.las = which.min(cv.las)

# one-standard-error rule for choosing lambda
i2.rid = max(which(cv.rid <= cv.rid[i1.rid]+se.rid[i1.rid]))
i2.las = max(which(cv.las <= cv.las[i1.las]+se.las[i1.las]))



plot.cv(cv.rid,se.rid,lam.rid,i1.rid)
plot.cv(cv.las,se.las,lam.las,i1.las)

plot.cv(cv.rid,se.rid,lam.rid,i1.rid,i2.rid)
plot.cv(cv.las,se.las,lam.las,i1.las,i2.las)


# c
#minimum cross-validation error
min(cv.rid)
min(cv.las)

# full dataset
a.rid = glmnet(X, y, alpha = 0, lambda = lam.rid)
a.las = glmnet(X, y, alpha = 1, lambda = lam.las)
barplot(height = a.rid$beta[,i1.rid])
barplot(height = a.las$beta[,i1.las])


 
plot.image(a.rid$beta[, i1.rid])
plot.image(a.las$beta[, i1.las])




# d and e
#squared error
sum((bstar - a.rid$beta[,i1.rid])^2)
sum((bstar - a.las$beta[,i1.las])^2)

#absolute error
sum(abs(bstar - a.rid$beta[,i1.rid]))
sum(abs(bstar - a.las$beta[,i1.las]))



