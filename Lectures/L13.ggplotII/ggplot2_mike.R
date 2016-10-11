#### Read file  ############
setwd("D:/User/Dropbox/EPID799B 2016/Data/NC Births/2012/")
births = read.table("births2012.tab", sep="\t", stringsAsFactors = F, header = T)
names(births) = tolower(names(births))

births_old = births

names(births)
table(births$wksgest)
nrow(births)

births = births[!(births$mdif %in% c(88,99)),]
births = births[births$wksgest != 99,]
births = births[births$sex != 9,]
births$sex = factor(births$sex, levels = 1:2, labels=c("M", "F"))


vars_to_lookat = c("mdif", "cigdur", "wic", "sex", "mage", "wksgest")
sample.int(n=nrow(births), size=1000)  
temp = births[sample.int(n=nrow(births), size=1000), vars_to_lookat]

library(ggplot2)

library(GGally)
ggpairs(temp)

############################
county_table = read.csv("county_table.csv")
births = merge(births, county_table) #will merge on same name
library(rgdal);library(sp)
NC_shapes = readOGR(dsn = "D:/User/Dropbox/EPID799B 2016/Data/NC shapefiles", layer="NC Counties2")

plot(NC_shapes)

temp = prop.table(table(births$countyname, births$wksgest < 37), margin = 1)
df = data.frame(countyID = names(temp[,1]), pct = round((temp[,1])*100, 0),stringsAsFactors = F)
NC_shapes_geo = merge(NC_shapes, df)

ggplot(data=df, aes())
