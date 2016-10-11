# debug.R
# examples for how to debug functions

### 1. Build a simple least-squares solver

# a. generate 100 x values
?rnorm
x <- rnorm(mean=10,sd=1,n=100)

# b. choose a real slope (effect)
real.slope <- 2

# c. generate 100 error terms
some.error <- rnorm(mean=0,sd=0.5,n=100)

# d. generate the 100 y values
y <- x*real.slope + some.error

### 2. Make a function to compute sum squared errors
sse <- function(slope) {
  # a. compute predicted value
  y.hat <- x*slope
  # b. calculate errors (predicted-actual)
  errors <- y-y.hat
  # c. square the errors
  errors.squared <- errors^2
  # d. sum the squares
  sum.errors <- sum(errors.squared)
  # e. return the result
  return(sum.errors)
}

# f. test your function
sse(1.5)
sse(2)
sse(2.5)

### 3. Try some function debugging tools
# a. Get optimize to work
optimize(sse,c(0,10))

# b. Trace your sse function
trace(sse)
optimize(sse,c(0,10))
untrace(sse)

# c. Return some code during the function call
trace(sse,quote(slope))
output <- function

?quote



optim(sse)
?solve
# browser() lets you pause in the middle of a function.
square <- function(x,y) {
  z <- x + y
  return(x)
}

square(3,4)


# trace reports calls to a function
trace(sum)
hist(rnorm(100))
untrace(sum)

debug(square)
square(3,4)
undebug(square)
