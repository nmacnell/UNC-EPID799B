#lab2.R

# 1. Create a vector
myname <- c("Nathaniel","Scott","MacNell")
myname  # print it

# 2. Create a vector with seq()
seq(from=2,to=100,by=2)

# 3. Stack vector commands
rep(seq(1,5),10)
# OR
short <- 1:5
rep(short,10)

# 4. What is the index?
41

# 5. Subset with repeated indices
let <- c("e","h","l","o")
let[c(2,1,3,3,4)]

# 6. reverse a vector
hello <- let[c(2,1,3,3,4)]
hello[5:1]
rev(hello) # secret trick

# 7. Operate on a whole vector
x <- 1:10 
sq <- x^2

# 8. Use the random number generator
n <- rnorm(n=1000,mean=10,sd=5)

# 9. Simplify data entry using rep()
bp <- c(rep("high",125),rep("medium",50),rep("low",25))

# 10. Summary statistics
summary(sq)

# 11. Try out some plots
# (We'll learn how to make them look good later!)
barplot(table(bp)) # good for categories
plot(density(n))  # can be helpful for large random data
hist(n) # more meaningful for real data
plot(ecdf(sq))  # good for small data

# 11. Plot by index
plot(1:10,sq)
plot(sq)  # this actually does the same thing.
# we're plotting by index i.e. showing a time series

### Lists ###
# 1. Build and slice a list of vectors
dat <- list(ID=c("A","B","C"),exposure=c("low","low","high"),
outcome=c(TRUE,TRUE,FALSE))
dat$exposure[2]

# 2. Build a dataset
person <- c("Me","Bro","Mom","Dad")
age <- c(27,24,54,57)
bday <- c("March","September","March","January")
family <- list(person=person,age=age,bday=bday)
family$age

### Practice ###
# 1. Days of the week
days <- c("N","M","T","W","H","F","S")
# 2. Date
date <- 8:14
# 3. Month
month <- rep("Feb",7)
# 4. List
time <- list(days=days,date=date,month=month)
# 5. Reference list
time$date[4]
# 6. Subset List
time$days[2:6]
# 7. Use built-in dataset
letters[c(1,2,1,4,3,1,2)]
# 8. Logical Query
# broken down so you can see what's happening
nums <- seq(2,20,2) # you don't have to name arguments
nums
greater <- nums > 10
greater
nums[greater]
# shorter version
nums[nums>10]
# I read this as "nums WHERE nums is greater than 10"
