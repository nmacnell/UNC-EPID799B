# demo.R
# R demonstration code file
# A whirlwind tour of things to do in R
# this is a comment

# you can run code by pressing Control+Enter
# (or Control+r) while your cursor is on a line.
# You can also run section by highlighting them
# and pressing the same key sequence.

# plots
x <- rnorm(mean=2,sd=0.5,n=1000)  # create a vector called x of random variables
e <- rnorm(mean=0,sd=1,n=1000)  # create 1000 error terms  
b <- rbinom(n=1000,size=1,prob=0.2)  # make a binary variable
y <- 3*x + 2*b + e  # create y based on x, b, and e
hist(x)           # histogram
boxplot(x,y,b,e)  # box-and-whisker plot
plot(x,y)         # scatter plot
plot(density(x))  # kernel density estimation
plot(ecdf(x))     # empirical cdf
plot(x,type="l")  # time-series plots: (try type= l,b,o,h, or s)
plot(e[1:100],type="l")
plot(e[1:100],type="b")
plot(e[1:100],type="o")
plot(e[1:100],type="h")
plot(e[1:100],type="s")
# define plot attributes
plot(x,y,pch=".")
plot(x,y,pch=20)
plot(x,y,pch=18,col="orange")
plot(x,y,col=rainbow(7))  # lots of extensions for color selection
plot(x,y,pch=5,cex=2)    # cex will change point size
plot(x,y,pch=5,cex=0.5)
# lines commands can also have options
plot(density(x),col="yellow",lwd=5)
plot(density(x),lwd=0.5)  # line width
plot(density(x),lty=2)    # line type
# axes are handled by yet more arguments
plot(x,y,  # keep running the lines below; R will listen until it gets a complete command        
     xlab="Value of X",
     ylab="Value of Y",
     main="My Informative nTitle",
     sub="Figure 1: A secondary title, or maybe a caption.")
# you can mix-and-match plot arguments, try also labeling these axes:
plot(x,y,xlim=c(0,4),ylim=c(0,14))
# changing to log scale
plot(x,y,log="x")
plot(x,y,log="y")
plot(x,y,log="xy")
# Overlaying plots
# Make sure the plots have the same axes, then use one of two methods:
# 1. lines() or points() draw on an existing plot(
plot(x,y,col="red",xlim=c(0,4),ylim=c(-2,14))
points(x,e,col="blue",xlim=c(0,4),ylim=c(-2,14))
# 2. use the argument add=TRUE for subsequent plots
hist(y,freq=FALSE,xlim=c(0,14),
     ylim=c(0,1),col="red")
hist(x,freq=FALSE,xlim=c(0,14),
     ylim=c(0,1),col="blue",add=TRUE)
# Annotating plots
# You can always draw things onto plots to make them look the way you want
# Typically, you supress defaults and then manually draw features
plot(x,e,col="blue",yaxt="n",xaxt="n",frame.plot=FALSE)
axis(side=2,pos=2)
axis(side=1,pos=0)
# Drawing horizontal and vertical lines can also help
plot(x,e,col="blue")
abline(h=0)
abline(v=2)
# Another option is drawing lines based on intercept/slope
plot(x,y,col="violet")
abline(a=2*mean(b),b=3,col="green")  # manually match our fake "model"

# Venn/Euler Diagrams
install.packages("VennDiagram")
library(VennDiagram)
overrideTriple=TRUE
venn.plot <- draw.triple.venn(200, 100, 100, 20,10,10,4,c("First", "Second","Third"));

# 3d plots
par(bg = "white")
x <- seq(-1.95, 1.95, length = 30)
y <- seq(-1.95, 1.95, length = 35)
z <- outer(x, y, function(a, b) a*b^2)
nrz <- nrow(z)
ncz <- ncol(z)
# Create a function interpolating colors in the range of specified colors
jet.colors <- colorRampPalette( c("blue", "green") )
# Generate the desired number of colors from this palette
nbcol <- 100
color <- jet.colors(nbcol)
# Compute the z-value at the facet centres
zfacet <- z[-1, -1] + z[-1, -ncz] + z[-nrz, -1] + z[-nrz, -ncz]
# Recode facet z-values into color indices
facetcol <- cut(zfacet, nbcol)
pdf("persp.pdf")
persp(x, y, z, col = color[facetcol], phi = 30, theta = -30)
dev.off()
shell.exec("persp.pdf")


# directed acyclic graphs
install.packages("dagR")
library(dagR)
dag <- demo.dag0()
daga <- dag.adjust(dag,3)
dag.draw(daga)

# social network analysis
install.packages("network")   
library(network)
download.file("http://www.unc.edu/~machardy/R/sna.RData",destfile="sna.RData")
load("sna.RData")
ties.basic <- ties[,1:2]
net.basic <- network(ties,attributes)
plot(net.basic)
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
# let's plot without colors
plot(net.basic,displaylabels=TRUE,edge.col=colors)
# Subnetworks
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

# visualize geographic data
install.packages("sp")
library(sp)
download.file("http://www.unc.edu/~machardy/R/greensboro.RData","gb.RData")
load("gb.RData")
pdf("map.pdf")
     p.black <- greensboro$pop.black/greensboro$pop.total
	p.black[is.na(p.black)] <- 0
	colors <- grey(1-p.black)
	plot(greensboro,col=colors)
	mtext("Greensboro, North Carolina")
dev.off()
shell.exec("map.pdf")

# geospatial statistics
install.packages("spdep")
library(spdep)
download.file("http://www.unc.edu/~machardy/R/nc.RData","nc.RData")
load("nc.RData")
# make neighbors object and plot on top on nc map
neighbors <- poly2nb(nc)
par(mar=rep(0,4))  # set margins to zero
plot(nc,border="grey")
plot(neighbors,coordinates(nc),add=TRUE)
# default type of spatial weights matrix
weights <- nb2listw(neighbors, style="U")
#Tests for autocorrelation
# Moran's I
moran.test(nc$income,weights)
moran.test(nc$lung.r,weights)
# Geary's C
geary.test(nc$income,weights)
geary.test(nc$lung.r,weights)
# Geographically Weighted Regression
# Basic model
mod.glm <- glm(nc$lung.r~nc$income)
summary(mod.glm)
# Spatial Error Model
# similar to GLM but also specify the weights matrix
# we have to lower the solution tolernace because
# we haven't bothered to properly scale the variables
# (this is an crude workaround to get an answer!)
mod.error <- errorsarlm(nc$lung.r~nc$income,listw=weights,
          tol.solve=1e-14)
summary(mod.error)
# Spatial lag model
mod.lag <- lagsarlm(nc$lung.r~nc$income,listw=weights,
               tol.solve=1e-14)
summary(mod.lag)

