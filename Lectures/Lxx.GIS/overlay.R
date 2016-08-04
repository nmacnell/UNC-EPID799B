# overlay.R
# example code to overlay 

# link libraries
library(rgeos)
library(rgdal)

# load up the two data sources
setwd("D:/CAFO/Analysis")
load("WorkData/mile3.RData")
load("../CleanData/NCBlocks/blocks.RData")

# project blocks into feet coordinates
nc = spTransform(blocks,CRS(proj4string(mile3)))

# get areas of blocks
nc@data$fullarea = gArea(nc,byid=TRUE)
# save(nc,file="WorkData/nc.RData")

# let's subset to onslow county to try gIntersect
# so we get an idea of how long it will take for the state
# the county code for onslow is 133
# onslow = nc[nc$COUNTYFP10=="133",]

# let's overlay these outselves to see what we expect
# this looks good, the county is about half covered
# plot(onslow)
# plot(mile3,add=TRUE,col="gray")

# now let's clip the onslow polygons by the buffer file
# this will give a topology exception without byid=TRUE and drop_not_poly=TRUE
# union = gIntersection(onslow,mile3,byid=TRUE,drop_not_poly=TRUE)

# let's go ahead and clip the state
within3 = gIntersection(nc,mile3,byid=TRUE,drop_not_poly=TRUE)
save(within3, file="WorkData/within3.RData")


# check it out
plot(union)

# import the QGIS file
clip3 = readOGR("../QGIS","clip3",encoding="ESRI Shapefile")

# calculate the areas of the clipped portions
clip3@data$area = gArea(clip3,byid=TRUE)

# extract the geoid codes and areas
clipareas = data.frame(GEOID10=clip3$GEOID10,area=clip3$area)

summary(is.na(to.append))

# append the clip areas to the existing nc dataset
# reorder the clipareas data
to.append = clipareas$area[match(nc@data$GEOID10, clipareas$GEOID10)]

head(nc$GEOID10,100) # this is messed up
head(clip3$GEOID10) # this is messed up too!


# check to make sure reordering worked
nc@data$GEOID10[1000] == to.append$GEOID[1000]

# append the data
nc@data = data.frame(nc@data,to.append)

# cool, save the results
save(nc,file="WorkData/clip3.RData")






