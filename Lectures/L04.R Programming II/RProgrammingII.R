# prog2.R
# fake regression example code from class
# EPID 799B UNC-CH
# Nathaniel MacNell

# create a random normal independet variable
bp  <- rnorm(n=1000, mean=120, sd=10)

# create a copy and trim to max of 120
bp1 <- bp
bp1[bp>120] <-120
hist(bp)

# create a random normal covariate
age <- rnorm(n=1000, mean=50,  sd=5 )

# glue together variables into a data frame
epi <- data.frame(bp,age)

# create a new dependent variable
# this is just an arthimetic equation
# but creates data consistent with the given model
# Note that an error term is added so that 
# we can estimate the consifdence intervals.
epi$crp <- bp*100 + age*5 + rnorm(n=1000,mean=0,sd=1)

# inspect the resulting dataset
names(epi)
head(epi)

# estimate a model and save to m1 model object
# I read ~ as "is predicted by" (model symbol)
m1 <- glm(crp ~ bp + age, data=epi)

# m1 is like a mini-dataset
summary(m1)
names(m1)

# you can use this property to pull out
# parts and do things with them
# (here, a plot of y versus residuals)
plot(crp,m1$residuals)

# let's make a binary version for logistic
# regression. First, create a new variale
crbp <- rep(NA,length(epi$bp))

# next, classify based on the value of bp
crbp[epi$crp > mean(epi$crp)] <- 1
crbp[is.na(crbp)] <- 0

# add the resulting variable to the data frame
epi$crbp <- crbp

# this is a logistic regression, just
# set the family option! (and feed in a
# binary variable on the left hand side)
m2 <- glm(crbp ~ age, data=epi, family=binomial("logit"))

# here is how we actually inspect the models
summary(m1)
summary(m2)

# the logistic regression is on the log scale
# so we need to exponentiate exp() the 
# coefficients and confidence intervals.
# coef() and confint() access these properties
exp(coef(m2))
exp(confint(m2))

# you can also get a series of plots
# of the model object:
plot(m2)


  