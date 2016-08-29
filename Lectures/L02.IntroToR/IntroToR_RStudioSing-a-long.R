#################################################################################
# R for Epidemiologists
# Classroom Exercise:  8/29/2016 "code-a-long"
# by Mike Dolan Fliss, Spring 2016
#################################################################################
# This classroom exercise is a "sing-a-long" on essential RStudio IDE concepts, 
# using a "toy" epidemiology analysis.
#################################################################################
# Notes: 
# Data came from http://arc.irss.unc.edu/dvn/dv/NCVITAL
# SHOW: shell.exec("http://arc.irss.unc.edu/dvn/dv/NCVITAL") 
# ^^ Q: Does this work on your machine?
# 1:30 video on the basics: https://www.rstudio.com/products/rstudio/
# Check out: # https://www.rstudio.com/resources/webinars/rstudio-essentials-webinar-series-part-1/
# ...for more details, but less epi-centric
# And look at code guidelines. 
# Google coding guidelines: https://google.github.io/styleguide/Rguide.xml
# Hadley Wickham's: http://adv-r.had.co.nz/Style.html  ....
#################################################################################


#### 1. Load births, poke around ################################################
# First, load the births three ways. Then poke around the datasets "en masse", 
# tabularly and graphically. 
#################################################################################
# You'll need to find your own file, below...
setwd("D:/User/Dropbox/EPID799B 2016/Data/NC Births/2012/") #SHOW: how to find a file; import dataset
births_orig = read.csv("births.csv") #note: can also use a web address here!
births = births_orig[, c("GEST", "KOTEL", "VISITS", "MDIF", "WKSGEST", "MRACE")] 
#names(births_orig) %in% c("GEST", "KOTEL", "VISITS") #jumping ahead, but consider...
head(births)

names(births) = tolower(names(births)) 
summary(births) 
str(births)
#SHOW: names/summary/str/View(filter): show copy-paste and (), "". Tab completion.

#For graphical exploration...
birth_sample = births[sample(nrow(births),1000),] #show in-line running, F1 on sample. (set.seed, later)
plot(birth_sample)

library(car) #install.packages("car") # A cool stats friendly package, SHOW comment running, graphical install.
scatterplotMatrix(birth_sample) #SHOW: Talk about errors, R trying its best.

library(corrplot); #install.packages("corrplot") #run install packages just once before next line
corrplot.mixed(cor(birth_sample), lower="ellipse", upper="number", order="hclust", addrect=2)
corrplot(cor(mtcars), order="hclust", method = "ellipse", addrect=3) #from one of the "native" datasets

#################################################################################
# Notes
# comments: #, # trick, no "block comments", but control-shift-C
# shortcuts are here: https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts
#    ...or Alt+Shift+K
# corrplot: https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html
#################################################################################


#### 2. Some down and dirty recoding ############################################
#################################################################################
births[births>80] = NA #slapdash, but ok for now. hits gest, mdif, wksgest
births$mrace.f = factor(births$mrace, levels=1:4, #NOTE the multi-line!
                        labels=c("White", "Black/AA", "AI/AN", "Other")) #not a great way to code race! going with it...
births$preterm = as.numeric(births$gest<37) #table(births$preterm, births$gest, usaNA="always")

library(tableone) #install.packages("tableone") #again, F1
CreateTableOne(data=births)
CreateTableOne(data=births, strata = "mrace.f")
summary(CreateTableOne(data=births)) #remember, it's an OO language...


# Feeling comfortable? Try ggpairs(birth_sample) using ggplot2 and the GGally package!
# ggpairs(births[sample(nrow(births), 1000),]); library(GGally)
#################################################################################
# Notes
# Importantly, these recoding are all a little bit WRONG!
#################################################################################


#### 3. A quick model, graph and some output ####################################
#################################################################################
plot(births$mdif, births$kotel)
births = births[complete.cases(births),] #what happened here? nrow to check.

model1 = lm(kotel ~ mdif, births) #Normally will drop NAs anyway, but good to be explicit...
model1
#plot(model1) #jump to console with control+2. Kinda weird: duh.
summary(model1)
plot(jitter(births$mdif), jitter(births$kotel), pch=".") #let's add jitter together?
abline(model1, col="red")

m1.summary = summary(model1)
round(confint(model1)[2,], 2)
cat("For every month later prenatal care began, the kotel score decreased by", 
    round(abs(m1.summary$coefficients[2,1]), 2), "points (95% CI", 
        paste(round(confint(model1)[2,], 2), sep=","), ").")
#SHOW: Close and reopen
#################################################################################
# Notes
# Again, remember, this is a "toy" analysis. Lots wrong here - linearity, coding, etc.
#################################################################################


#### After. Poke around in R Studio #################################################
#datasets F1
#library(help="datasets")
#shell.exec("https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/00Index.html")
plot(esoph) #Smoking, Alcohol and (O)esophageal Cancer - case control
head(airquality)
plot(USAccDeaths)

#demo(graphics)
#browseVignettes() #check out, for example: ggrepel, GGally, ggthemes, survival

#################################################################################
# Notes
# Many packages include their own "classic" datasets to standarize questions. 
# ...ggplot2, for example, includes the "diamonds" dataset, which you'll see a lot.
# Google is usually VERY helpful: #2 hit = http://www.statmethods.net/graphs/scatterplot.html
#Consider StackExchange
#e.g. http://gis.stackexchange.com/questions/148398/how-does-spatial-polygon-over-polygon-work-to-when-aggregating-values-in-r
#################################################################################


