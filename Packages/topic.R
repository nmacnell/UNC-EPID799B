# topic.R

# point to files
setwd("D:/LearnR/topic")

# import one .csv as a data frame
aug14_1 <- read.csv("csv/aug14_1.csv")

# inspect variable names
names(aug14_1)

# trim off blank variables
aug14_1 <- aug14_1[,1:12]

# load tm package
install.packages("tm") # once per computer
library(tm) # once per R session

# tm creates "corpus" objects to store text.
# "virtual" corpus is stored in memory, 
# "permanent" corpus is stored in an external database.

# It's easiest to construct a virtual corpus from a vector:
corpus1 <- VCorpus(VectorSource(aug14_1$TEXT))

# how to look at a corpus
inspect(corpus1) # print out the entire corpus
corpus1[[1]] # print the first document from corpus

# strip whitespace
corpus2 <- tm_map(corpus1,stripWhitespace)
corpus2[[1]]  # see part of result

# convert to lowercase
corpus3 <- tm_map(corpus2,content_transformer(tolower))
corpus3[[1]]  # see result

# remove stopwords
corpus4 <- tm_map(corpus3, removeWords, stopwords("english"))
corpus4[[1]]
names(aug14_1)
head(aug14_1[,1:11])


# stemming
install.packages("SnowballC") # once per computer
library(SnowballC)
corpus5 <- tm_map(corpus4, stemDocument)
corpus5[[1]]

### Topic Models
# get topicmodels set up
install.packages("topicmodels")
library(topicmodels)

# Subet to a few documents.
# You have to build a vector of TRUE/FALSE values
# this code keeps the first 100 elements
keep <- meta(corpus5,"id") %in% 1:100
corp <- corpus5[keep]

# creating a document-term matrix
dtm <- DocumentTermMatrix(corp)

# look at words appearing more than 20 times
findFreqTerms(dtm,20)

# look at how many times "prison" and "offend" appears in each
dct <- DocumentTermMatrix(corp,list(dictionary=c("prison","offend")))
inspect(dct)

# look at correlation between "prison" and "offend"
findAssocs(dct,"prison",0)

# build a correlated topic model
install.packages("lasso2")
library(lasso2)
dtm <- DocumentTermMatrix(corp) # built doc-term matrix
# let's say we expect 3 topics:
# rehabilitation
# retribution
# deterence
ctm <- CTM(dtm,k=3) # k is the number of topics (uses VEM)

# inspect the model (boring stuff)
logLik(ctm) # log-likelihood
perplexity(ctm)

# inspect the model - cool stuff!
topic <- topics(ctm,1) # topic classification of each document
topic
terms <- terms(ctm,10) # 10 most common terms in each topic
terms






