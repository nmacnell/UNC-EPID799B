### dataI.R
# activity to practice data management recipes and explore
# two new data types: factors and dates. EPID 799B.

# Instructions:
#  Answer the questions below. Skip around between question
#  numbers if you need to (letters are in order within questions).
#  Comments that start with a capital letter show where you 
#  should write your own code!



### 0. Import
# Note that this expression is two lines!
births <- read.csv("https://github.com/MacNell/UNC-EPID799B/raw/master/Datasets/births.csv",
            stringsAsFactors = FALSE)
# What were the variables again?
names(births)



#### 1. Factors

# A. Create a factor() called ppb from PPB default settings.
# (This variable is prior preterm birth)
ppb <- factor(births$PPB)

# B. Create a table() and plot() of your debault ppb variable.
# How are the levels ordered? 
table(ppb)
plot(ppb)

# C. Use the levels and labels arguments to make a factor with this
#    order of (fuller) labels: Yes, No, Unknown. Plot to make sure.
ppb2 <- factor(births$PPB,levels=c("Y","N","U"),
               labels=c("Yes","No","Unknown")    )
plot(ppb2)



### 2. Loops
# APGAR5 and APGAR10 are ratings for baby responsiveness at
# 5 and 10 minutes. APGAR10 is not performed if the baby
# has a good enough score at 5 minutes (APGAR5)

### For this section, you can do either A or B first ###

# A. Use a loop and if statements to create a new variable called 
#    pgar that contains the latest non-missing apgar score.
#    (Missing values are 99. 88 is used when APGAR10 isn't collected).
#    Optional hint: to test if something is in a set, you can use 
#    %in%. I.e. 88 %in% c(88, 99) and 99 %in% c(88,99) are TRUE
for(i in 1:length(births$APGAR5)) {
  if(births$APGAR10[i] %in% c(88,99)) {
    births$apgar[i] = births$APGAR5[i]
  } 
  else{
    births$apgar[i] = births$APGAR10[i]
  }
  if(births$apgar[i] == 99) {
    births$apgar[i] = NA
  }
  cat(i,"\n")  # keep track of how long it takes to run!
}
table(births$apgar)

# B. Use vectorization to accomplish A more easily
#    Hint: You'll need to start with one variable and
#    selectively fill in values from the other.
#    Make sure the length of the replacement matches!
births$apgarB <- births$APGAR10
births$apgarB[births$apgarB %in% c(88,99)] <- births$APGAR5[births$apgarB %in% c(88,99)]
births$apgarB[is.na(births$apgarB)==99] <- NA
table(births$apgarB)



### 3. Dates
# We haven't covered dates. Can you figure out how to use them?

# A. Transform births$DOB into a date value using as.Date()
#    Hint: look at arguments listed on the ?as.Date page.  
#    Does the argument for "format" look like it will work?
?as.Date
date <- as.Date(births$DOB)

# B. Using your new date variable, what is the maximum number
#    of babies born on one day?
max(table(date))

# C. Using the which() funcition and a logical test, which
#    date has the maximum number of babies born?
which(table(date)==max(table(date)))

# D. What is the day number of date with the least number of
#    babies born in in the entire year?
#    Hint: you can subtract dates to calculate the days
#    between then.
which(table(date)==min(table(date)))
as.Date("2012-04-29") - as.Date("2012-01-01")



### 4. Data transformation

# A. Rename the PPO variable (other previous poor pregnancy
#    outcome) so that it is not confused with PPO (preferred
#    provider organization) care status.
names(births)[names(births)=="PPO"] <- "priorpoorpreg"

# B. Use TOTPREG to restrict the dataset to include only physician
#    attended births (ATTEND 1 or 2) to mothers mothers for 
#    whom this is their first birth.
births2 <- births[births$TOTPREG==1 & births$ATTEND %in% c(1,2),]

# C. Identify a Y/N variable of your choice. Impute unknown values
#    of this variable using a random draw based on the prevalence
#    of Y and N responses in the rest of the dataset.
#    Hint: you can use rbinom() to generate a 1/0 variable.
#    A logical test based on runif() will also work!
tab = table(births$INFT)
p = tab[3] / (tab[1] + tab[3])
n.missing = tab[2]
births$INFT[births$INFT=="U"] <- ifelse(rbinom(size=1,n=n.missing,p)==1,"Y","N")




