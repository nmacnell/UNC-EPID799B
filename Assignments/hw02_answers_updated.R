#################################################################################
# R for Epidemiologists
# Homework 2:  Answer script
# by Mike Dolan Fliss, Fall 2016
# modified by Xiaojuan Li
#################################################################################
# Objectives
# Use existing functions for some tasks that need to specify values for multiple arguments
# Create your own functions
# -Simple ones you can compare the output from an existing function
# -Complex ones
# -involving loops
# -Conditional execution (if...else.)
# Subsetting
#################################################################################

### Q1: Read and subset   #######################################################
# a. Read in births.csv file into a data.frame 
setwd("~/Dropbox/EPID799B 2016/Data/NC Births/2012")    #change to your specific path
births = read.csv("births.csv", stringsAsFactors = F, header = T)
# if using the dta file
# births = read.table("births2012.tab", sep="\t", stringsAsFactors = F, header = T)

# b. Subset the datafile
births = births[, c("MAGE", "SEX", "MDIF", "VISITS", "WKSGEST", "MRACE", "CIGDUR")]

# c. change the data.frame elements to lowercase
names(births) = tolower(names(births))


### Q2: Functions: My dog Lima  #################################################
### Creating Functions 
# a.
my_dog = function (bean){
  cat("My dog", bean, "likes to roam.\n")
  cat("One day", bean, "left his home!\n")
  cat("He came back all nice and clean.\n")
  cat("Where oh where had", bean, "been?\n")
  cat(bean, "been!\n", bean, "been!\n")
  cat("Where oh where has", bean, "bean?\n\n")
}

# b. Rrun the function with a dog name of your choice
my_dog("Lima")
my_dog("Coffee Bean")
# Call and run this function with one or two "beans" of your choice. 
# You might consider the below list: Lima, Coffee, Pinto, Espresso, Bean, Bean-Bean.


### Q3: Loops & vectors: Numeric ##################################################
# a. Write a for-loop that iterates through the length of the vector a=1:10, 
# adds 1 to the element at that position, and prints it out
a = 1:10; for (i in 1:length(a)){cat("Number:",a[i]+1,"\n")}

# b. Write a for-loop that iterates through the letters of the alphabet by 
# numeric position and prints out "The letter _.", where _ is replaced by the 
# letter of the alphabet. 
for (i in 1:length(letters)){ cat("The letter ", letters[i], ".\n", sep="")}

# c. Write the same for-loop as before, but loop through the letters themselves 
# without using their numerical index. 
for (i in letters){ cat("The letter ", i, ".\n", sep="")}



### Q4: Loops & vectors: cigdur #################################################
# a. explore the current contents of the (now lowercase) cigdur variable
table(births$cigdur)

# b.	SAS style: create a new variable smoke1 in the births dataset and assign it to zero.  
# Loop through the length of the births dataset using the position integer i. 
# Depending on whether the ith cigdur variable is Y, N or U, recode smoke1 to 1, 0 or NA respectively
births$smoke1 = 0
for(i in 1:length(births$cigdur)){
  if(births$cigdur[i] == "Y") {
    births$smoke1[i] = 1
  } else if (births$cigdur[i] == "N"){
    births$smoke1[i] = 0
  } else {
    births$smoke1[i] = NA
  }
}

# c.	Create an integer variable smoke2 from cigdur using three vector assignment statements 
births$smoke2 = 0
births$smoke2[births$cigdur == "Y"] = 1
births$smoke2[births$cigdur == "N"] = 0
births$smoke2[births$cigdur == "U"] = NA
table(births$smoke2)

# d. Create an integer variable smoke3 using the ifelse() function. 
births$smoke3 = ifelse(births$cigdur == "Y", 
                       1, ifelse(births$cigdur == "N", 
                                 0, NA))
table(births$smoke3)

# e. recode() in car package
library(car)
births$smoke4= recode(births$cigdur,"'Y'=1; 'N'=0; else=NA")


### Q5: Write the file #################################################
# a. write.csv() is an instance of a more generic function write.table()
# b. the first argument by position is the object to be written
# c. the default for row.names = TRUE
write.csv(births, file ="births_v2.csv")
# d. 
write.csv(births, file ="births_v2a.csv", row.names=F)
