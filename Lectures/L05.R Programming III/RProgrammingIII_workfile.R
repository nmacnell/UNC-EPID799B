#######################
# R programming III   #
# EPID 799B           #
# Fall, 2016          #
# Xiaojuan Li         #
#######################

#### Packages ####
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


# Step 2. create a new dataframe;        SAS equivalent: data births1; set births; run; 

  
# Step 3. examine the dataframe
## understand the datastructure;         SAS equivelant: proc contents data=births1;run;


## check for missing data


## print out all data;          SAS equivalent: proc print data = births1;run;


## print out a variable;        SAS equivalent: proc print data = births1; var sex; run; 


## print out the first 10 rows;  SAS equivalent: proc print data=mydata (obs=10);run;

## print out the last 5 rows;   


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


## 2-way frequency table;      SAS equivalent: proc freq data = births; tables marital*sex; run;



## three-way frequency table;  SAS equivalent: proc freq data = births; tables mrace*marital*sex; run;


# Step 5. more descriptive work; histogram or boxplot of mage


# Step 6. Subset dataset;      SAS equivalent: Data births1; set births; where 20<=mage<99 and sex ^=9; run;


# Step 7. recode a variable;   SAS equivalent: Data births; set births; if sex=1 then female =0; else if sex=0 then female=1;else female=.; run;

