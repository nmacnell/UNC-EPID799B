# gss.R
# example geospatial statistics

# load spdep package
# install.packages("spdep") # run once
library(spdep)

# load data
setwd("D:/LearnR/GSS")
load("nc.RData")

nc$income <- as.numeric(gsub(",","",as.character(nc$income)))
save(nc,file="nc.RData")


### Create a neighbor object
# make neighbors object
neighbors <- poly2nb(nc)

# inspect neighbors object
neighbors
class(neighbors)

# plot alone
plot(neighbors,coordinates(nc))

# plot on top on nc map
par(mar=rep(0,4))
plot(nc,border="grey")
plot(neighbors,coordinates(nc),add=TRUE)



### Spatial weights matrices
# let's try the default type of matrix
weights <- nb2listw(neighbors)

# inspect weights list
class(weights)

# this is a funky object, but here are some
# access methods
names(weights)        # look at the attributes
# Within this oject, $weights are the weights
# and $neighbors are the corresponding neighbors.
# Notice that in this example the weights add to 1.
weights$weights[1]    # 
weights$neighbours[1] # note the british spelling

# try inspecting some other weights matrices
weights <- nb2listw(neighbors,style="U")
# style="B"  binary coding
# style="W"  row weights add up to 1
# style="C"  ALL weights add up to number of links
# style="U"  weights add up to 1
# style="S"  Tiefelsdorf et al 1999 scheme



### Tests for autocorrelation
# Moran's I
moran.test(nc$income,weights)
moran.test(nc$lung.r,weights)

# Geary's C
geary.test(nc$income,weights)
geary.test(nc$lung.r,weights)



##### Geographically Weighted Regression
# all of these models are

### non-spatial model
# Is income associated with lung cancer?
mod.glm <- glm(nc$lung.r~nc$income)
summary(mod.glm)

### Spatial Error Model
# similar to GLM but also specify the weights matrix
# we have to lower the solution tolernace because
# we haven't bothered to properly scale the variables
# (this is an crude workaround to get an answer!)
# in reality this merits further data management.
mod.error <- errorsarlm(nc$lung.r~nc$income,listw=weights,
          tol.solve=1e-14)
summary(mod.error)

### Spatial lag model
mod.lag <- lagsarlm(nc$lung.r~nc$income,listw=weights,
               tol.solve=1e-14)

summary(mod.lag)





