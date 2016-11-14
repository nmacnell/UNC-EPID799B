rm(list=ls())

library(statnet)
setwd("") # set to the folder where *.csv and *.R files are 

el <- read.csv("edgelist.csv", header=FALSE)
# head(el)

net <- network(el, directed=FALSE, matrix.type="edgelist")

# what is in the network object? 
# mel - edge attributes 
# gal - network attributes 
# val - vertex attributes 
# iel - in-degree edglist 
# oel - out-degree edgelist

# what kinds of attributes can we look at? 
list.vertex.attributes(net)

# use the %v% shortcut to refer to vertex attributes 
net %v% "vertex.names"

# now, let's add some vertex attributes
# first read-in dataset with vertex attributes 
vdata <- read.csv("vertex_data.csv", header = TRUE, stringsAsFactors = FALSE)
head(vdata)

net %v% "sex" <- vdata$sex
list.vertex.attributes(net)
plot(net, vertex.col = "sex") # red is male, black is female

net %v% "grade" <- vdata$grade
plot(net, vertex.col = "grade")

# end - importing data ------------------------------------------------

# part 2: distance and geodesics --------------------------------------
distances <- geodist(net)
attributes(distances)

distances$gdist[1, ]
distances$counts[1,]

# end - distances  ----------------------------------------------------

# part 3: centrality measures -----------------------------------------

vdata$degree <- degree(net)
vdata$close <- closeness(net)
vdata$bet <- betweenness(net)
vdata$eigen <- evcent(net)

pairs( ~ eigen + close + bet + degree, data = vdata)

# let's look at the local networks around nodes with high centrality ---
source("extraction.R")

which.max(vdata$eigen) # find vertex with largest eigenvector 
hi.eigen.graph <- extract.graphs(net, 18, level = 2)
plot(hi.eigen.graph$subgraph, label = "vertex.names")

# what about the vertex with the highest betweenness? 




# what happens if we remove the person with the highest betweenness score? 
which.max(vdata$bet)

