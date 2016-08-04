# database.R
# example code for importing access (and other ODBC/DBMS) databases

### Step 1: get the RODBC package set up

install.packages("RODBC") # run once
library(RODBC)


### Step 1: establish a database connection

# option a: manual
setwd("D:/LearnR") # point to where your database is
mydatabase <-odbcConnectAccess2007("mydatabase.accdb")

# option b: select using a menu instead
mydatabase <- odbcDriverConnect()

### Once you have a connection, you can pull tables or submit queries

# Grab a table as a data.frame by name
nutrition <- sqlFetch(mydatabase,"Nutrition")


# Submit sql-like query to database to get more complex tables or vectors
demographics <- sqlQuery(mydatabase,"select * from Demographics")
demographics
jobs <- sqlQuery(mydatabase,"select Job from Demographics")
jobs

