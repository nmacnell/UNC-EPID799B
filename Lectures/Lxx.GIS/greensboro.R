# point this where your data is.
load("Desktop/greensboro.RData")
library(sp)

pdf("mymap.pdf")
  plot(greensboro)
dev.off()

names(greensboro)

p.black <- greensboro$pop.black/greensboro$pop.total
l
ength(greensboro$pop.black)
length(greensboro$distance)/6130

d <- matrix(greensboro$distance,ncol=8)
dim(d)
d.min <- apply(d,1,min)
length(d.min) # looks good

#classify data
close <- 1*(d.min < 5280)
black <- 1*(p.black > 0.5)

summary(d.min)
table(close)

mod.linear <- glm(close~black)
summary(mod.linear)
confint(mod.linear)
