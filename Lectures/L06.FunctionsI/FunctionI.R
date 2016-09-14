#######################
# Functions I         #
# EPID 799B           #
# Fall, 2016          #
# Xiaojuan Li         #
#######################


###### Functions #######
# to tell if an object is a function
is.function(sum)
is.primitive(sum)      # a primitive function
is.function(sample)

# to see the code for a predefined function, just run the function name without ()
sample
mean
sum
rnorm

# to see the arguments 
args(sample)   

# the order of the argument values matter if you are not specifying the argument
ls <- 1:100
sample(ls, 20)
sample(x=ls, size=20)
sample(size=20, x=ls)       #equivalent to the previous lines, but not the following
sample(20, ls)

sample(s=20, x=ls, r=TRUE)  #equivalent to the following
sample(size=20, x=ls, replace=TRUE)

# to get help
?rnorm
??rnorm
help(rnorm)
example(lm)          # to see a worked example

find("lowess")       # find the package something is in
find("plot")

apropos("lm")        # display all objects in the search list that match your enquiry

# read in a data set
births <- read.csv("https://github.com/MacNell/UNC-EPID799B/raw/master/Datasets/births.csv")
head(births)
names(births)
summary(births$MAGE)

# correlation
cor(births$MAGE, births$GEST)

# missing
births$female[births$SEX==1] <-0
births$female[births$SEX==2] <-1
births$female[births$SEX==9] <-NA

# calling functions
mean(births$female)             # returns NA if any of the input values are NA
mean(births$female, na.rm=TRUE) # excludes NAs from the calculation

length(births$female)         # count number of observations
sum(is.na(births$female))     # count number of missing values
sum(!is.na(births$female))    # count number of nonmissing values


###### for loops ######
for(i in c(1,3,6,9))
{
  z<- i*2
}
z


for(i in c(1,3,6,9))
{
  z<- i*2
  print(z)
}


