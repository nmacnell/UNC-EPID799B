##### geocoding.R
# example for how to geocode using RDSTK

### set up environment (packages/wd)
install.packages("RDSTK")
library(RDSTK)
install.packages("rgdal")
library(rgdal)
install.packages("sp")
library(sp)
install.packages("rgeos")
library(rgeos)
setwd("/home/nat/Maps")

### import GIS file of orange county
unzip("tl_2010_37135_bg10.zip")  # unzip files from within R!
orange <- readOGR(".","tl_2010_37135_bg10")
proj4string(orange)  # looks okay
plot(orange)  # also looks okay

# set up test addresses dataset
the.address <- "117 cole st., Chapel Hill, NC"
addresses <- rep(the.address,20)

### do the geocoding and extract the coordinates
geocoded <- lapply(addresses,street2coordinates)
pointdata <- do.call("rbind",geocoded)
coords <- cbind(pointdata$longitude,pointdata$latitude)

### The SpatialPointsDataFrame constructor lets you keep the 
# rest of data columns too!
homes <- SpatialPointsDataFrame(coords=coords,proj4string=CRS(proj4string(orange)),data=pointdata)

# Test plot
plot(orange)
points(homes,co="red",pch=19) # pch=19 is a BIG marker type

# Test data
names(homes)

# Figure out which block group you're in
where.homes.are <- homes %over% orange
where.homes.are
