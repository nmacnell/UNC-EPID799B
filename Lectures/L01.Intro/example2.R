# lab1.R

# 1. print the value of pi
pi

#2. create name, age, awake
age <- 27
name <- "Nat"
awake <- TRUE

#3. print name, age, awake
age
name
awake

#4. average of 130, 133, 128
(130+133+128)/3

#5. 45 modulus 4
45%%4

#6. which is more cookies?
12*12 > 11*13  # yes

#7. painfully complex logic
!(name == "Nat")!=TRUE|FALSE&TRUE
# no idea what this does!
# the point is that you should
# write simpler expressions

### Practice questions
# 1. paste without spaces
?paste()
# look at arguments!
# the sep argument allows you to select the seperator
# set this to "" (i.e. nothing)
paste("b","2001",sep="")

#2. try to figure out plot() 
plot(2,4) # does this work?
# yes!
?plot # also helpful if you can't figure it out
# you can see the first two arguments are x and y

#3. sample 100 standard normal distributions
?rnorm  # look up arguments
rnorm(n=100,mean=0,sd=1)

#4. type changing
my.text <- "1" # dots are just like other characters
my.number <- as.numeric(my.text)
my.logical <- as.logical(my.number)
my.logical
as.numeric(as.logical("1"))  # missing value!
as.logical(as.numeric("2"))  # TRUE?!?!?!
# non-zero numbers will contert to TRUE
as.logical(-1)
as.logical(0)

#5. Re-writing code
x <- 2*(4+5)
y <- 8/3
z <- abs(-9)
sum(x,y,x)

#6. make code more readible
sum(1,2,3,4)

#7/8. make a case/control solver
eo <- 800
Eo <- 200
eO <- 50
EO <- 50
OR <- (EO*eo)/(Eo*eO)
SElnOR <- sqrt(1/eo+1/Eo+1/eO+1/EO)
LCL <- exp(log(OR)-1.96*SElnOR)
UCL <- exp(log(OR)+1.96*SElnOR)
CLR <- UCL/LCL # let's get fancy
# print results
OR
LCL
UCL
CLR










