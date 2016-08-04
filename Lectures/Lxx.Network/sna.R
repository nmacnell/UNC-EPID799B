##### sna.R
# introduction to social network analysis in R

### adapted from / dataset from / thanks to:
# McFarland, Daniel, Solomon Messing,
# Mike Nowak, and Sean Westwood. 2010. 
# "Social Network Analysis          
# Labs in R." Stanford University.                                       
# more labs: http://sna.stanford.edu/rlabs.php

### set up environment
# install packages(if needed)
install.packages("network")    # basic network objects
install.packages("igraph")     # more plotting options
install.packages("sna")        # analysis functions
install.packages("intergraph") # easy network conversions

# load packages
# you'll get some messages about "objects are masked"
library(network)
library(igraph)
library(sna)
library(intergraph)

# set the working directory so we know where stuff is
setwd("D:/LearnR/SNA")

# load the social network data
# this was prepared using the data source listed above
# you can see the file sna-build.R to see how I
# built this dataset for this example
load("sna.RData")

### inspect the data
# look at the objects inside
# you should see "attributes" and "ties"
ls()

### inspect the individual objects
head(ties)
# the "ties" data contain one tie for each row
# and the type of tie (1/0) as variables
# ego is who the link is from 
# alter is who the link goes to

head(attributes)
# the attributes dataset contains more traditional data
# there is one row per person

### Basic networks
# let's start by building a basic network object
# we don't care about direction ot type
ties.basic <- ties[,1:2]

net.basic <- network(basic.ties,attributes)

# basic plot of basic network object
par(mar=c(0,0,0,0))  # set margins to zero
plot(net.basic)

# there are plenty of options to try out e.g.
plot(net.basic,displaylabels=TRUE)

# let's color code by the type of tie:
# advice = blue
# friendship = yellow
# report = red
# and to make the color combos make sense:
# advice/friend = green
# advice/report = purple
# friend/report = orange
# all types = black
colors <- rep(NA,length(ties))
colors[ties$advice==1] <- "blue"
colors[ties$friendship==1] <- "yellow"
colors[ties$report==1] <- "red"
colors[ties$advice==1 & ties$friendship==1] <- "green"
colors[ties$advice==1 & ties$report==1] <- "purple"
colors[ties$friendship==1 & ties$report==1] <- "purple"
colors[ties$friendship==1 & ties$report==1 & ties$advice==1] <- "black"
table(colors) # check

# let's plot with out colors
plot(net.basic,displaylabels=TRUE,edge.col=colors)

### Subnetworks
# sometimes you are interested in subnetworks
# these can be built easily by subsetting the ties dataset
ties.report <- ties[ties$report==1,]
ties.advice <- ties[ties$advice==1,]
ties.friendship <- ties[ties$friendship==1,]

net.report <- network(ties.report,attributes)
net.advice <- network(ties.advice,attributes)
net.friendship <- network(ties.friendship,attributes)

# inspect
plot(net.report)  # hierarchical structure
plot(net.advice)  # looks pretty dense
plot(net.friendship)  # much looser

### Let's compare some of the network properties
network.density(net.report)
network.density(net.advice)
network.density(net.friendship)
# as expected, the density of the advice network is highest
network.density(net.basic)
# we can also see the basic net has the highest
# density, since it include all ties!

### Network conversion
# Some packages use their own network objects
# but you can easily convert between them
# the igraph package calls them graphs
graph.basic <- asIgraph(net.basic)

# can still be easily plotted; different style!
plot(graph.basic)

# some network properties can be assessed for each node
centralization.betweenness(graph.basic)

