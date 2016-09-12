#######################
# R programming III   #
# EPID 799B           #
# Fall, 2016          #
# Xiaojuan Li         #
#######################

#### Packages ####
library()

## install a package - first time on your machine you'll need to install the package
install.packages("ggplot2")

## load a package - whenever you first want to use the package during an R session
library(ggplot2)

#### getting help ####
?read.csv
help(read.csv)
help.search("read.csv")
example(plot)       # run example of a function
args(rm)            # display arguments of a function

#### housekeeping ####
# list objects in the workspace
ls()
objects()

# To remove all objects you have created
rm(list=ls(all =  TRUE))

# To remove some objects you have created
rm(a, b, c)

# To clean the Console: ctrl + L or 
cat("\f")
cat("\014")  


#### Group Exercise ####
# Step 1. read in a data set
births <- read.csv("https://github.com/MacNell/UNC-EPID799B/raw/master/Datasets/births.csv")

# Step 2. create a new dataframe;        SAS equivalent: data births1; set births; run; 
births1 <- births
  
# Step 3. examine the dataframe
## understand the datastructure;         SAS equivelant: proc contents data=births1;run;
str(births1)
names(births)
dim(births)
summary(births)

## check for missing data
unique(is.na(births))
births[!complete.cases(births),]    # from class

## print out all data;          SAS equivalent: proc print data = births1;run;
births1

## print out a variable;        SAS equivalent: proc print data = births1; var sex; run; 
mydata$bp
mydata[,"bp"]

births$SEX
births[, "SEX"]

## print out the first 10 rows;  SAS equivalent: proc print data=mydata (obs=10);run;
head(births)
head(births, n=10)
births[1:10,]     #object-oriented, so use matrix notation ; birth[1:10] prints out all observations of the first 10 columns  

## print out the last 5 rows;   
tail(births, n=5)

#SAS equivalent
# %let obswant = 10;
# data want;
# do _i_=nobs-(&obswant-1) to nobs;
# set have point=_i_ nobs=nobs;
# output;
# end;
# stop;  /* Needed to stop data step */
#  run;



# Step 4. create a frequency table
## 1-way frequency table;      SAS equivalent: proc freq data = births; tables marital mnat; run;
table(births$MARITAL)
table(births$MNAT)

## 2-way frequency table;      SAS equivalent: proc freq data = births; tables marital*sex; run;
table(births$MARITAL, births$SEX)  #(row, column) 

## if missing is invovled
table(births$MARITAL, births$SEX, exclude=NULL)

## getting marginal frequency
table1 <- table(births$MARITAL, births$SEX)

### row margins
margin.table(table1, 1)

### column margins
margin.table(table1, 2)

## three-way frequency table;  SAS equivalent: proc freq data = births; tables mrace*marital*sex; run;
table(births$MRACE,births$MARITAL, births$SEX)

# Step 5. more descriptive work
hist(births$MAGE)
boxplot(births$MAGE)
qplot(MAGE, geom="histogram", binwidth=0.5, data=births)

# Step 6. Subset dataset;      SAS equivalent: Data births1; set births; where 20<=mage<99 and sex ^=9; run;
births1 <- subset(births, MAGE>=20 & MAGE <99)
births2 <- births[births$MAGE>=20 & births$MAGE <99,]  #note the comma
births3 <- subset(births, MAGE>=20 & MAGE <99 & SEX!=9, select=c(MAGE, TERM, SEX))  #note the comma, also case of argument matters too
                                                                                    #! is the logical negation
births4 <- subset(births, (MAGE>=20 & MAGE <99) | SEX!=9, select=c(MAGE, TERM, SEX))

# Step 7. recode a variable;   SAS equivalent: Data births; set births; if sex=1 then female =0; else if sex=0 then female=1;else female=.; run;
births$female[births$SEX==1] <-0
births$female[births$SEX==2] <-1
births$female[births$SEX==9] <-NA

table(births$female)
table(births$female, exclude=NULL)


births$female1[births$SEX==1] <-"No"
births$female1[births$SEX==2] <-"Yes"
births$female1[births$SEX==9] <-NA

table(births$female1)
table(births$female1, exclude=NULL)
