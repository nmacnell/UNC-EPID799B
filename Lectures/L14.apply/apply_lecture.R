# code from apply activity
# class 10/12/2016
setwd("C:/Users/Nathaniel/Downloads")
births <- read.csv("births.csv",
          stringsAsFactors = FALSE)

### 1. subset data to morbidities
morb <- births[ , 83:88 ] 
head(morb)

### 2. make a table of all morbidities at once
# old style example: attach two tables together 
rbind(
  table(morb[,1]),
  table(morb[,2])
)

# new style: apply
# note the use of an inline function
# remember that 2 here means do it to each column
apply(morb,2,function(i) table(i,useNA = "no"))
# you can use t() to rotate the table
# if you like this layout better!
t(apply(morb,2,function(i) table(i,useNA = "no")))

### 3.  add up the Y values
# remember that 1 here means do it to each ROW
morbid <- apply(morb,1,function(i) sum(i=="Y"))

# our results
table(morbid)

### 4. USe aggregate function (similar) to apply by groups
# the list() is a wrapper that allows you to put in multiple
# grouping variables if you want (works like c() but more general).
aggregate(morbid,
          by=list(births$TOTPREG==1),
          mean)

# example matrix from the slides
m <- matrix(1:100,nrow=10)


