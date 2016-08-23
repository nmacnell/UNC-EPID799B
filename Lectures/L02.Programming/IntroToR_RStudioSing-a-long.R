#################################################################################
# R for Epidemiologists
# Classroom Exercise:  8/23/2016
# by Mike Dolan Fliss, Spring 2016
#################################################################################
# This classroom exercise is a "sing-a-long" on essential RStudio IDE concepts
#################################################################################


#### 0. Poke around in R Studio #################################################

#################################################################################

#### 1. Load some libraries, read the file ######################################
setwd("D:/User/Dropbox/EPID799B 2016/Data/NC Births/2012/")
births = read.table("births2012.tab", sep="\t", stringsAsFactors = F, header = T)
#################################################################################

# What is an IDE
# 
# IDE is flexible - markdown, etc.
# Content sing-a-long
# window nav
# 
# poking around: F1
# comments: #, # trick, no "block comments", but control-shift-C

# END: workspace image

#################################################################################
# https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts / Alt+Shift+K
#################################################################################
plot
datasets
shell.exec("https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html")

plot(esoph)
plot(USAccDeaths)

plot(USArrests)
head(USArrests)
install.packages("")


### 2. Basic operations on datasets ##############################################
# Use basic functions on dataset
# View, summary, head, str
#View(births)
#edit(births) #never do this, but...
summary(births)
head(births); tail(births) #mashing
str(births)
names(births)
dim(births)
#################################################################################
# Challenges
births_mod = births; names(births_mod) = tolower(names(births_mod))

births_subset = births[sample(nrow(births), size=500), c("MAGE","MEDUC", "MDIF", "APGAR5", "VISITS", "GEST", "KOTEL")]
library(car); #install.packages("car") #run install packages just once before next line
scatterplotMatrix(births_subset) 
#See: http://www.statmethods.net/graphs/scatterplot.html

library(corrplot); #install.packages("corrplot") #run install packages just once before next line
corrplot.mixed(cor(births_subset), lower="ellipse", upper="number", order="hclust", addrect=2)
corrplot(cor(mtcars), order="hclust", method = "ellipse", addrect=3)
#See: https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html

#shell.exec("http://arc.irss.unc.edu/dvn/dv/NCVITAL") #Does this work on your machine?
#################################################################################


### 2. Basic Operators ##########################################################
# Use [], $, (), as well as arithmatic, boolean, assignment operators
#################################################################################
#MAGE
births[,22] #all MAGE
births[1,22] #first MAGE
hist(births$MAGE)
min(births$MAGE); max(births$MAGE)
range(births$MAGE)
median(births$MAGE)
quantile(births$MAGE)
mean(births$MAGE)
mage_modified = births$MAGE - mean(births$MAGE)
hist(mage_modified)

#weeks
weeks = births$WKSGEST #wish this was called something easier!
table(weeks)
hist(weeks)
weeks==99
sum(weeks==99)
table(weeks>=37)
boxplot(weeks)

#bedcode
str(births)
unique(births$BEDCODE)
table(births$BEDCODE)

#prenatal care
table(births$MDIF)
sum(births$MDIF >= 88)
