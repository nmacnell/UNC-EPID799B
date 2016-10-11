#################################################################################
# R for Epidemiologists
# Homework 1:  Answer script
# by Mike Dolan Fliss, Fall 2016
# modified by Xiaojuan Li
#################################################################################
# This homework covers basic assignment operators. 
# Think about coding style
# https://google.github.io/styleguide/Rguide.xml#comments
# Try to practice your efficient coding / keystrokes as well
# https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts / Alt+Shift+K
#################################################################################e

View(births)


#### 1. Load some libraries, read the file ######################################
## a. read in the file into a dataframe
births <- read.csv("https://github.com/MacNell/UNC-EPID799B/raw/master/Datasets/births.csv", 
                   stringsAsFactors = FALSE)
## b. print the first few rows 
head(births)
#################################################################################
## c. Optional Challenges:
setwd("D:/User/Dropbox/EPID799B 2016/Data/NC Births/2012/")
births = read.table("births2012.tab", sep="\t", stringsAsFactors = F, header = T)


#### 3. Basic operations on datasets ############################################
## a. Use basic functions on dataset
# View, summary, head, str
# View(births)
summary(births)
head(births); tail(births) #mashing
str(births)
names(births)
dim(births)
## b. summary statistics for varaibles
summary(births$WKSGEST)
summary(births$MDIF)
#################################################################################
## Optional Challenges: 
# Run these lines and see if you can tell what they're doing
births_mod = births; names(births_mod) = tolower(names(births_mod))

#### 4. Subsettting, loading packages & making graphics##########################
## a. create a subset of the births file
names(births)
births_sample = births[1:1000, c("MAGE", "MDIF", "VISITS", "WKSGEST", "MRACE")]

## b. plot this dataset at once
plot(births_sample)
summary(births_sample)
#################################################################################
## c. Optional Challenges: 
# Run these lines and see if you can tell what they're doing
library(car); #install.packages("car") #run install packages just once before next line
births_sample = births[sample(nrow(births), size=1000), c("MAGE", "MDIF", "VISITS", "WKSGEST", "MRACE")]
scatterplotMatrix(births_sample) 
#See: http://www.statmethods.net/graphs/scatterplot.html

# Another way
library(corrplot); #install.packages("corrplot") #run install packages just once before next line
corrplot.mixed(cor(births_sample), lower="ellipse", upper="number", order="hclust", addrect=2)
corrplot(cor(mtcars), order="hclust", method = "ellipse", addrect=3)
#See: https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html

# ggpair in ggplot
library(mice)
library(ggplot2); library(GGally)
ggpairs(births_sample)


### 5. Basic Operations on data columns##########################################
# Use [], $, (), as well as arithmatic, boolean, assignment operators
#################################################################################
## a. MAGE
# a. create a table of MAGE
table(births$MAGE)

# c. assign MAGE=99 to R's missing value
births$MAGE[births$MAGE==99] <- NA

# d. distribution of MAGE 
boxplot(births$MAGE)
hist(births$MAGE)
plot(density(births$MAGE))

min(births$MAGE); max(births$MAGE)
range(births$MAGE)
median(births$MAGE)
quantile(births$MAGE)

# e. centered age variable
mage_modified = births$MAGE - mean(births$MAGE)
summary(births$mage_modified)
hist(births$mage_modified)
sd(births$mage_modified)
boxplot(births$mage_modified)


## b. prenatal care
# a. table of MDIF
table(births$MDIF)
sum(births$MDIF >= 88)

# c. deal with missing value
births$MDIF[births$MDIF==88|births$MDIF==99] <- NA
table(births$MDIF, exclude =FALSE)

# d. univariate plot for MDIF
hist(births$MDIF)

## c. cigdur
# a. recode the variable
table(births$CIGDUR)
births$smoke[births$CIGDUR=="N"] = 0; births$smoke[births$CIGDUR=="Y"] = 1; births$smoke[births$CIGDUR=="U"] = NA

# b. frequency table
table(births$smoke, births$CIGDUR, useNA = "always")


