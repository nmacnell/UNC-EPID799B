# demo.R
# R demonstration code file
# this is a comment

# you can run code by pressing Control+Enter
# (or Control+r) while your cursor is on a line.
# You can also run section by highlighting them
# and pressing the same key sequence.

### 1. Importing and inspecting data
#
# By default,
# R will put everything in your documents folder.
# to change this, uncomment the line below and 
# edit to your desired directory, then run it:
# setwd("C:/Users/Nathaniel/Documents")

# 1.1 download example data from internet
# this example uses NHANES II data
download.file("http://learnr.web.unc.edu/files/2014/10/adult.csv","adult.csv")
download.file("http://learnr.web.unc.edu/files/2014/10/exam.csv","exam.csv")
download.file("http://learnr.web.unc.edu/files/2014/10/lab.csv","lab.csv")

# 1.2 import .csv files (easiest method in R)
adult <- read.csv("adult.csv")
exam <- read.csv("exam.csv")
lab <- read.csv("lab.csv")

# 1.3 inspect datasets
names(adult)  # list variable names
names(exam)
names(lab)
dim(adult)  # view observations, vars

# 1.4 merge datasets
lab.exam <- merge(lab,exam,by="SEQN")
nhanes <- merge(adult,lab.exam,by="SEQN")

# 1.5 rename variables
#
# note that R keeps reading until it
# "completes the sentence" (command).
# The + prompt indicates R is waiting for
# more imput.
#
# you can also highlight this section
# and run it all at once
names(nhanes) <- c("id", "obs", "status", 
                   "race", "sex", "age", "age.unit", 
                   "sample.phase", "sample.ppsu", 
                   "sample.pstrat", "sample.weight", 
                   "education", "diag.chf", "diag.stroke", 
                   "last.bp", "diag.htn", "diag.htn2", 
                   "medicine", "last.chol", "diag.chol", 
                   "medicine.chol", "diag.ha", "cig100", 
                   "smoke", "chol", "trig", "sys1", 
                   "dia1", "sys2", "dia2", "sys3", 
                   "dia3", "sys", "dia", "bmi", 
                   "teen.pregnant", "pregnant"
)

# 1.7 print values of a variable
nhanes$age

### 2. Descriptive Statistics

# 2.1 univariate statistics
names(nhanes)
mean(nhanes$age)
sd(nhanes$age)
median(nhanes$education)
summary(nhanes$sys1)

# 2.2 tables
table(nhanes$education)
table(sex=nhanes$sex,smoke=nhanes$smoke)
aggregate(nhanes$bmi,by=list(nhanes$sex),mean,na.rm=TRUE)
min(nhanes$bmi)

#####   6. Create some factors for the analysis
race <- factor(nhanes$race, levels=1:4,
               labels=c('White',
                        'Black', 
                        'Latino',
                        'Other')	)
sex <- factor(nhanes$sex, levels=1:2,
              labels=c('Male','Female'))

#####   7. Create a function to automate some of the factorization
yesno <- function(variable) {
  y <- factor(variable,levels=1:2,labels=c('Yes','No'))
  return(y)
}

# use the function on these variables.
cig100 <- yesno(nhanes$cig100)
smoke  <- yesno(nhanes$smoke)
diag.chf <- yesno(nhanes$diag.chf)
diag.ha <- yesno(nhanes$diag.ha)
diag.stroke <- yesno(nhanes$diag.ha)
diag.htn <- yesno(nhanes$diag.htn)

#####   8. Prepare continous variables
table(nhanes$age)  # looks okay
table(nhanes$education)  # 88 and 99 are missing codes
nhanes$education[nhanes$education>20] <- NA
table(nhanes$chol) # 888 is missing
nhanes$chol[nhanes$chol==888] <- NA
table(nhanes$trig)  # 8888 is missing
nhanes$trig[nhanes$trig==8888] <- NA
table(nhanes$sys) # 888 is missing
nhanes$sys[nhanes$sys==888] <- NA
nhanes$dia[nhanes$dia==888] <- NA



########## ===== Part II: Graphics options and Parameters ===== ##########

#####   1. Create a Scatter Plot (2 continous variables)

# Create vector of color codes for each point.
colors = rep("",length(nhanes$sys))
colors[cig100=="Yes"] <- "red"
colors[cig100=="No"] <- "blue"

# Create the means of each group
sys.0 <- mean(nhanes$sys[cig100=="No"],na.rm=TRUE)
sys.1 <- mean(nhanes$sys[cig100=="Yes"],na.rm=TRUE)
dia.0 <- mean(nhanes$dia[cig100=="No"],na.rm=TRUE)
dia.1 <- mean(nhanes$dia[cig100=="Yes"],na.rm=TRUE)
sys.d <- round(sys.1-sys.0,2)
dia.d <- round(dia.1-dia.0,2)

pdf("bp.pdf")
# use jitter() to spread points apart a bit so you can see them all
plot(jitter(nhanes$sys),jitter(nhanes$dia),
     pch=".",
     main="Blood pressure in the NHANES III Cohort",
     xlab="Systolic Blood Pressure (mmHg)",
     ylab="Disastolic Blood Pressure (mmHg)",
     col=colors)
# draw some lines for the averages
abline(v=sys.0,col="blue",lty=2)
abline(v=sys.1,col="red",lty=2)
abline(h=dia.0,col="blue",lty=2)
abline(h=dia.1,col="red",lty=2)
# annote some text
text(x=140,y=20,labels=expression(Delta[sys]==3.05))
text(x=85,y=80,labels=expression(Delta[dia]==1.88))

dev.off()

#####   2. Plot a glm object (multiple graphs at once)
mod.plot <- glm(nhanes$dia ~ nhanes$sys)
# Press ENTER to skip through each plot
plot(mod.plot)

### Put it into a pdf
pdf("glm.pdf")
plot(mod.plot)
dev.off()

### Put each into a seperate part of the plot
par(mfrow=c(2,2))
plot(mod.plot)
mtext("Regression Diagnostics",side=3,line=-2,outer=TRUE)

##### 5. Barplot
par(mar=c(4,4,4,4))
par(mfrow=c(1,1))
tab <- table(cig100,race)
pct <- round(prop.table(tab,2),2)
coords <- barplot(tab,main="Smoking History of Participants by Race",ylab="Count")
text(x=coords,y=tab[1,],pct[1,],pos=3)
legend(c("<100 Cigarettes",">100 Cigarettes"),x="topright",fill=gray.colors(2))





