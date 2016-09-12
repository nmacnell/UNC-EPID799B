
set.seed(1)

library(circular)
# generate 100 random numbers
X=rbeta(100,shape1=2,shape2=4)*24
?
X
Omega=2*pi*X/24
summary(Omega)

# These units are in radians
Omegat=2*pi*trunc(X)/24
Omegat


H=circular(Omega,type="angle",units="radians",rotation="clock")
Ht=circular(Omegat,type="angle",units="radians",rotation="clock")
par(mar=c(1,1,1,1))
plot(Ht, stack=FALSE, shrink=1.3, cex=1.03,
     axes=FALSE,tol=0.8,zero=c(rad(90)),bins=24,ylim=c(0,1))
points(Ht, rotation = "clock", zero =c(rad(90)),
       col = "1", cex=1.03, stack=TRUE )
?rose.diag
rose.diag(Ht-pi/2,bins=24,shrink=0.33,xlim=c(-2,2),ylim=c(-2,2),
          axes=FALSE,prop=1.5)
Ht

?rose.diag

bad <- circular(X)
rose.diag(bad)

x <- circular(c(pi, pi/3, pi/4))
print(x)
is.circular(x)

windrose(x=c(pi,pi/2),y=c(0.5,1))


# generate some data from scratch
degrees <- seq(from=0,to=355,by=5)
conc <- abs(rnorm(0,1,n=length(degrees)))

# scale data to do wind rose
conc100 <- 100*conc
conc100

?plot.windrose

windrose(degrees,conc)

?rose.diag
plot.circular(conc)

r <- 1
theta <- 2*pi/8
width <- 2*pi/16

plot.circle <- function(thetas,r,width) {
  for(i in 1:length(thetas)) {
    x <- c(0,r[i]*cos(theta[i]+width),r*cos(theta[i]-width))
    y <- c(0,r[i]*sin(theta[i]+width),r*sin(theta[i]-width))
    cat(theta[i])
    polygon(x,y)  
  }
}

# example
plot.new()
plot.window(c(-2,2),c(-2,2))
plot.triangle(pi/8,1,pi/16)
plot.triangle(pi/4,0.5,pi/16)

plot.triangle <- function(theta,r,width) {
  x <- c(0,r*cos(theta+width),r*cos(theta-width))
  y <- c(0,r*sin(theta+width),r*sin(theta-width))
  return(polygon(x,y))  
}

plot.circle <- function(theta,r,width) {
  for(i in 1:length(theta)) {
    plot.triangle(theta[i],r[i],width)
  }
}


library(plotrix)

testpos<-seq(0,350,by=10)
polar.plot(testlen,testpos,main="Test Polar Plot",lwd=3,line.col=4)
oldpar<-polar.plot(0,testpos,main="Test Clockwise Polar Plot",
                   radial.lim=c(0,15),start=90,clockwise=TRUE,lwd=3,line.col=4,rp.type="s")
angle8 <- seq(0,pi*2-pi*2/32,pi*2/32)
conc8 <- abs(rnorm(mean=5,sd=1,n=32))
plot.circle(angle8,conc8,width=pi/32)


conc8 <- abs(rnorm(mean=5,sd=1,n=32))

myplot <- function(conc) {
  # plot gridlines
  oldpar<-polar.plot(0,testpos,main="",
                     radial.lim=c(0,15),start=90,clockwise=TRUE,lwd=3,line.col=4,rp.type="s")

  # figure out the angle measures
  segments <- length(conc)
  seg.width <- pi*2/segments
  angle <- seq(0,pi*2-seg.width,seg.width)

  plot.circle(angle,conc,width=seg.width/2)
}

myplot(abs(rnorm(mean=10,sd=2,n=72)))
