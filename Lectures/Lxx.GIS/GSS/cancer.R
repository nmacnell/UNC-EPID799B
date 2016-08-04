# cancer.R
# script to import cancer counts
# make sure to change the working directory below

setwd("D:/LearnR/GSS/")

# import cancer data
# we'll have to import in two steps and then join,
# since the data manager decided to make the
# data file pretty instead of useful.

cancer1 <- read.csv("leadingcancers.csv",
         skip=7,header=FALSE,nrows=50)
cancer2 <- read.csv("leadingcancers.csv",
         skip=71,header=FALSE,nrows=50)
cancer <- rbind(cancer1,cancer2)
names(cancer) <- c("county","colon.n","colon.r","lung.n","lung.r","breast.n","breast.r","prostate.n","prostate.r","cancer.n","cancer.r")
save(cancer,file="cancer.RData")

# import spatial data
library(rgdal)
library(rgeos)
ogrInfo(".","nc")
nc <- readOGR(".","nc")
plot(nc)  # test

# import covariate data
income <- read.csv("income.csv")

# merge income and cancer data
dat <- merge(income,cancer, by="county")

# order data to append to shapefile
keys <- match(nc$NAME10, dat$county)
# make sure we matched correctly
table(dat$county[keys] == nc$NAME10)
# append to dataset
nc@data <- data.frame(nc@data,dat[keys,])
save(nc,file="nc.RData")




