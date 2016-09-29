#######################
# Data management II  #
# EPID 799B           #
# Fall, 2016          #
# Xiaojuan Li         #
#######################

### 0. read in dataset ##
births <- read.csv("https://github.com/MacNell/UNC-EPID799B/raw/master/Datasets/births.csv", 
                   stringsAsFactors = FALSE)



### 1. add a column  
# A. a single value
births$col1 <- 5       # run this line and 
table(births$col1)     # find the distribution of this new column col1


# B. a vector
income <- seq(10000, 24000, by=100)
births$col2 <- income   

income <- c(seq(10000, 24000, by=100), rep(NA, 122372))
births$col2 <- income 



### 2. change the column label
# A. What are the variables?
names(births)

# B. Change the name "col2" to "IncomeUSD"
names(births)[names(births)=="col2"] <- "IncomeUSD"

# C. Check the variable names again
names(births)



### 3. delete a column
# A. Option 1 - assign NULL to that column, col1
births$col1 <- NULL

# B. Option 2 - use subset function to delete column IncomeUSD
births <- subset(births, select=-IncomeUSD)
names(births)

# If deleting multiple columns at once - both col1 and IncomeUSD
births <- subset(births, select=c(-col1, -IncomeUSD))



### 4. subset data frame
# A. Option 1 - use subset() function to create a new data frame sub.0 where MAGE > 30
sub.0 <- subset(births, MAGE > 30)

sub.1 <- subset(births, SEX == 1 & MAGE > 30)    # new data frame sub.1 where MAGE > 30 and SEX=1
sub.2 <- subset(births, SEX == 1, MAGE)          # how many variables are in this new sub.2 data frame?

# B. Option 2 - by position
# select a dataframe sub.3 which contains all observations of variables SEX, MAGE, DOBYEAR
sub.3 <- births[c(15, 23, 13)]
sub.3a <- subset(births, select=c(SEX, MAGE, DOBYEAR))

head(sub.3)
# C. Option 2 - by name
# select a dataframe sub.4 which contains the first 50 observations of variables SEX, MAGE, DOBYEAR 
sub.4 <- births[1:50, c("SEX", "MAGE", "DOBYEAR")]
table(sub.4$SEX)


### 5. rearrange columns - so that the new order in sub.4 is DOBYEAR, SEX, MAGE
sub.4 <- sub.4[, c(3,1,2)]
sub.4a <- sub.4[c(3,1,2)]


### 6. sort a data frame by a column
# examine the first several rows of the data frame sub.4
head(sub.4)

# order by MAGE
sub.4 <- sub.4[order(sub.4$MAGE),]
head(sub.4)

# order by MAGE and SEX
sub.4 <- sub.4[order(sub.4$MAGE, sub.4$SEX),]  # first by MAGE, then by SEX, default order is ascending
head(sub.4)

sub.4 <- sub.4[order(sub.4$MAGE, -sub.4$SEX),]  # first by ascending MAGE, then by SEX descending
head(sub.4)

# what about missing values?
births$SEX[births$SEX==9] <- NA
table(births$SEX, exclude=NULL)
births1 <- births[order(births$MAGE, births$SEX),]  
head(subset(births1, select=c(MAGE, SEX)))          # NA is put last as na.last=TRUE

births2 <- births1[order(births1$SEX, na.last= FALSE),]
head(subset(births2, select= SEX))  



### 7. Merging data frames
# A. take two subsets of the data frame
data1 <- births[1:500, c("X", "MAGE", "MRACE")]
data2 <- births[1:500, c("X", "SEX", "DOB")]
data2 <- data2[order(data2$SEX), ]
names(data2)[names(data2)=="X"] <- "X2"
head(data1)
head(data2)

# B. merge these two subsets by X
data3 <- merge(data1, data2, by.x="X", by.y="X2")

# compare to the original data frame to see if the merge was successful
head(data3)
head(subset(births, select=c("X", "MAGE", "MRACE", "SEX", "DOB")))

# C. use cbind()
data3.0 <- cbind(data1, data2)        # may not give you what you expect
head(data3.0)

table(births$CIGDUR)

for (i in 1:length())
if (births$CIGDUR[i] =="U") {
  births$smoke[i] = NA
} else if (births$CIGDUR[i] =='Y'){
  births$smoke[i] = 1
} else if (births$CIGDUR[i] == 'N'){
  births$smoke[i] = 0
}


### 8. Joining data frames
data4 <- births[1:500, c("X", "MAGE", "MRACE")]
data5 <- births[501:1000, c( "MAGE", "X","MRACE")]
head(data4)
head(data5)

data6<- rbind(data4, data5)



### 9. Transposing data frame 
name <- c("bob", "amy", "kai")
sex <- c("m", "f", "m")
before <- c(150, 135, 190)
after <- c(152, 130, 180)

weight <- data.frame(name, sex, before, after)

# A. from wide to long
install.packages("reshape2")
library(reshape2)
long <- melt(weight, id.vars=c("name","sex"), variable.name="timepoint", value.name="weight")

melt(weight, id.vars="name",variable.name="timepoint", value.name="weight")
melt(weight, id.vars="name", measure.vars=c("before", "after"), variable.name="timepoint", value.name="weight")

# B. from long to wide
dcast(long, name + sex ~ timepoint, value.var="weight")
