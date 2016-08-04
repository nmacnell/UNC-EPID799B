data(CO2)

# inspecting an object
head(CO2)
tail(CO2)
class(CO2)
str(CO2)
names(CO2)

# print the code for making an object
dput(CO2$conc)

# download directly from internet
download.file()
unzip()  # also unzip the file from within R

# reference multiple variables in same dataset
with(CO2,conc*uptake)

# concatenate a list (use a list as arguments)
l <- list(1,2,3,4)
do.call(c,l)
ld <- list(CO2,CO2,CO2)
do.call(rbind,ld)

# trace errors
options(error=dump.frames)
options(error=recover)
options(error=stop)

# parse text for SAS-style macros
bp.1 <- "120/80" # variable of interest
var.name <- "bp.1"
eval(parse(text=var.name))

# PROC FREQ
aggregate(CO2$uptake ~ CO2$Type + CO2$conc,FUN=mean)

undebug(sum)
debug(glm)
glm(rnorm(1,1,100) ~ rnorm(1,1,100))

undebug(glm)

debug(rnorm)
rnorm(1,1,100)

log(mean(sum(x)))
traceback()
example(mean)
example(glm)
