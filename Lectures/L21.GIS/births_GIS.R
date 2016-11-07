# Homework 05 : Regression
# Make sure to set your working directory below!

### Previous Homework
### Read file

setwd("D:/User/Dropbox/Education/EPID799B 2016/Data/NC Births/2012")
#setwd("C:/Users/Nathaniel/Dropbox/EPID799B 2016/Data/NC Births/2012/")  
births = read.table("births2012.tab", sep="\t", stringsAsFactors = F, header = T)

#births = births[, c("MAGE", "SEX", "MDIF", "VISITS", "WKSGEST", "MRACE", "CIGDUR")] # Subset
names(births) = tolower(names(births)) # change the data.frame elements to lowercase
names(births)

### Recode variables ##########################################################
# Prep: sex, smoking, dob/weeknum, PNC, 
###############################################################################
#sex
births$sex_f = factor(births$sex, levels = c(1,2), labels=c("M", "F"))
table(births$sex_f, births$sex, useNA = "always") #How to check recoding
#smoking
births$smoke_f = factor(births$cigdur, levels= c("Y","N"))
#date of birth
births$dob_d = as.POSIXct(births$dob, format = "%Y-%m-%d")
births$weeknum = as.numeric(strftime(births$dob_d, format="%W"))+1
#PNC : as a numeric, and factor
births$pnc5 = as.numeric(births$mdif <= 4)
births$pnc5_f = cut(births$mdif, breaks=c(0, 4, 88), 
                    labels=c("Early (1-4)", "No Early PNC"))
table(births$pnc5_f, births$pnc5, useNA="always")
### TODO: mage, mage2, race, raceeth
table(births$mage, useNA = "always")
births$mage[births$mage==99]=NA
#mage2 - indicator for low and high ages, reference level 29
births$mage2 = births$mage
births$mage2[births$mage2 < 15] = 14
births$mage2[births$mage2 > 43] = 44
births$mage2 = factor(births$mage2); 
births$mage2 = relevel(births$mage2, ref="29")
#preterm
births$preterm = as.numeric(births$wksgest >= 20 & births$wksgest < 37)
table(births$preterm, births$wksgest, useNA="always")
###############################################################################
# NOTES: Missing some variables here, like race.
# 
###############################################################################


### Exclusion criteria ########################################################
# Drop records that didn't have full at-risk 
# period, or with congenital anomalies
###############################################################################
# 1. Has gestation data (weeks), and at least 20 weeks gestation pre-birth (weeks >= 20)
births$excl_hasgest = as.numeric(births$wksgest!=99)
births$excl_enoughgest = as.numeric(births$wksgest >= 20)
# 2. Less than 20 weeks gestation before Jan 1 of year (LMP > Aug 20), or weeks-weeknum>=19, w/ weeknum=1 for Jan 1-7
births$excl_lateenough = as.numeric(births$wksgest - births$weeknum <= 19)
# 3. Start date of gestation was 45 (max gest in'11) w prior to Jan 1 of next year, so all births are observed in year
# This part was missing from the homework
births$excl_earlyenough = as.numeric(births$wksgest - births$wksgest <=7)
# 4. singletons only
births$excl_singleton = as.numeric(births$plur == 1)
births$excl_hasnumdata = as.numeric(births$plur != 9)
# 5. no congential anomylies 
drop.anom = c("anen","mnsb","omph","cl","cdh","dowt","cdit","cchd","limb","hypo")
#births$excl_hasanomdata = as.numeric(apply(births[,drop.anom]!=9, FUN=all, 1)) #All not missing = not any missing
births$excl_noanomalies = as.numeric(apply(births[,drop.anom]=="N", FUN=all, 1)) #All not present
table(births$excl_noanomalies)

eligibility.drops = nrow(births) - apply(births[,grepl("excl_", names(births))], FUN=sum, MARGIN = 2)
old_births = births; nrow(old_births)
births = old_births[apply(births[,grepl("excl_", names(births))], FUN=all, MARGIN = 1),]
warnings() # Just letting me know I'm casting those 1s as TRUEs. That's ok.
cat("Leaving eligibility checks with n =", formatC(nrow(births), big.mark = ","), "births.")
###############################################################################



###############################################################################
# GRAPHS
###############################################################################
### NOTE This set was written for the 2003 dataset, and needs updating.
### Need to integrate previous homework recoding. I like the ### HWX QY format... 
### talk on Monday
# library(ggplot2);
# 
# npop = formatC(sum(!is.na(births$weeks)), big.mark=',')
# ggplot(data=births, aes(x=weeks, y=..prop..))+geom_bar() + #Does what you need, as does geom_histogram()
#   labs(title="Figure 1: Proportional distribution of gestational age at birth", 
#        subtitle=paste0("From ", npop, " births in NC in 2003 from the NC SCHS, posted at Odum Institute"), 
#        x="Weeks of gestation", y="Proportion of population") + 
#   theme_bw()
# 
# #A2.1 : Working with weeknum. - shoukld double check this. Just used %V above.
# hist(births$weeknum, breaks = min(births$weeknum):max(births$weeknum)) # Looks weird
# 
# #A2.2 : Graph weeknum
# ggplot(births, aes(x=weeknum, y=..prop..)) + geom_bar() +
#   labs(title="Throwaway: Investigating Weeknum", 
#        subtitle="N.B. : Weeknum needs some work, doesn't quite match SAS", 
#        x="Week number of birth", y="Proportion of population") +
#   theme_bw()
# 
# #A2.3 : weeks vs. weeknum
# # Could also sample, since this can take some time, with something like births[sample(12000, 10000),]
# ggplot(births, aes(x=weeks, y=weeknum)) + 
#   geom_point(alpha=.05) + 
#   geom_jitter(width=1, height=1)+
#   labs(title="Throwaway: week vs. weeknum", 
#        subtitle="Does this match what we expect given the inclusion criteria? \n NB Consider tabling first, so  we could size by points", 
#        x="weeks of gestation", y="week number of birth in year")+
#   theme_bw()
# 
# library(ggplot2);library(GGally)
# births_subset$mrace = factor(births_subset$mrace)
# births_subset = births_subset[births_subset$mage != 99 & 
#                                 births_subset$mdif !=99 & 
#                                 births_subset$mdif !=88, ]
# ggpairs(births_subset, mapping=aes(color=mrace))

###############################################################################
# Regression Examples
###############################################################################
model.a1 = lm(data=births, preterm~mage)
summary(model.a1)
confint(model.a1)
coef(model.a1)

library(broom)
tidy(model.a1)

lm(data=births, preterm~mage*smoke_f)
births$smoke_f2 = relevel(births$smoke_f, ref = "N")

births$smoke_f = factor(births$cigdur, levels= c("Y","N", "U"))


x_range = min(births$mage, na.rm=T):max(births$mage, na.rm=T)

predict(model.a1)


toplot = predict(model.a1, newdata = data.frame(mage=x_range)) #Can use for IPTW generation

toplot2 = predict(model.a1, interval="confidence", newdata = data.frame(mage=x_range))

str(toplot2)
plot(toplot)
model.b = lm(data=births, preterm~mage2)
summary(model.b)
plot(model.b)

###############################################################################
# NOTES: See assignments 3, 4, 5 in 716
###############################################################################

### HW5 Activities
# Outcome: preterm
# Main exposure: kotel

# 1. Crude model
m.crude <- glm(births$wksgest<37 ~ (births$kotel == 1), family=binomial("log"))
summary(m.crude)
exp(coef(m.crude))
exp(confint(m.crude))
births$cigdur
# 2. full model
m.full <- glm(births$wksgest<37 ~ (births$kotel==1) + (births$mage>33) + (births$cigdur=="Y"), family=binomial("log"))
summary(m.full)
exp(coef(m.full))
exp(confint(m.full))
# 3. change in estimate
(coef(m.full)[2]-coef(m.crude)[2])/coef(m.full)[2]
# not a 15% change, so use the crude model.

###############################################################################
# GIS
###############################################################################
library(rgdal)
library(sp)
library(rgeos) #for spatial poly poly over

counties = readOGR(dsn="D:/Public Health Data/_GIS/General GIS/Base shape files/NC Counties 2014/.", layer="NC Counties2")
plot(counties)
#zips = readOGR(dsn="D:/Public Health Data/_GIS/General GIS/Base shape files/NC ZIP codes/.", layer="zcta")
#plot(zips, lty=3, co="blue")

# spatial over to get max zip to county table
# https://cran.r-project.org/web/packages/sp/vignettes/over.pdf
# http://gis.stackexchange.com/questions/40517/using-r-to-calculate-the-area-of-multiple-polygons-on-a-map-that-intersect-with

### Toy example
#########################
x = c(0.5, 0.5, 1.0, 1.5)
y = c(1.5, 0.5, 0.5, 0.5)
xy = cbind(x,y)
dimnames(xy)[[1]] = c("a", "b", "c", "d")
pts = SpatialPoints(xy)
xpol = c(0,1,1,0,0)
ypol = c(0,0,1,1,0)
pol = SpatialPolygons(list(
  Polygons(list(Polygon(cbind(xpol-1.05,ypol))), ID="x1"),
  Polygons(list(Polygon(cbind(xpol,ypol))), ID="x2"),
  Polygons(list(Polygon(cbind(xpol,ypol - 1.0))), ID="x3"),
  Polygons(list(Polygon(cbind(xpol + 1.0, ypol))), ID="x4"),
  Polygons(list(Polygon(cbind(xpol+.4, ypol+.1))), ID="x5")
))
plot(pol); plot(pol["x5",], border="blue", add=T)
plot(pts, pch="x", add=T)
####

obj = over(pol[1:4,], pol[5,])
obj = over(pol[5,], pol[1:4,])
obj = over(pol[5,], pol[1:4,], returnList = T)
obj = over(pol[1:4,], pol[5,], returnList = T); str(obj)
# For each of the first, tell me the overlap of the second...?

library(rgeos)
library(maptools)
obj = gIntersection(pol[1:4,], pol[5,], byid = T)
str(obj); plot(obj, add=T, co="green")

### births maps
#########################
# https://www.r-bloggers.com/mapping-with-ggplot-create-a-nice-choropleth-map-in-r/
# http://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html
counties = readOGR(dsn="D:/Public Health Data/_GIS/General GIS/Base shape files/NC Counties 2014/.", layer="NC Counties2")
str(counties[1,])
head(counties@data)

library(broom) # convert into a df.
head(counties@data)
counties.tidymap = tidy(counties, region = "NAME")
head(counties.tidymap)

library(ggplot2)
library(ggthemes) #for theme_map()
names(counties.tidymap)
head(counties.tidymap)
ggplot(counties.tidymap, aes(x=long, y=lat, group=group))+
  geom_polygon(aes(fill=id), color="grey")+
  guides(fill=FALSE) + theme_map()

### join data in.
library(dplyr)
county_agg_table = births %>%
  group_by(cores) %>%
  summarise(n = n(), 
            n_preterm = sum(preterm, na.rm=T),
            n_pnc5 = sum(as.numeric(pnc5_f == "Early (1-4)"), na.rm=T)) %>%
mutate(pct_preterm = n_preterm/n*100, pct_pnc5 = n_pnc5/n*100)
head(county_agg_table)

counties$cores = as.numeric(as.character(counties$COUNTYFP))
counties_with_results = merge(counties, county_agg_table, by="cores")

##Not merging right
View(county_agg_table)
View(counties@data)

### Now, to QGIS!
setwd("D:/User/Dropbox/Education/EPID799B 2016/Lectures/L21.GIS/")
writeOGR(counties_with_results, layer="NC birth results", dsn = ".", 
         driver = "ESRI Shapefile", overwrite_layer = T) 
shell.exec("NC birth results QGIS project.qgs")

#Plot with ggplot
#http://rforpublichealth.blogspot.com/2015/10/mapping-with-ggplot-create-nice.html

head(counties_with_results@data)

temp = tidy(counties_with_results, region = "NAME")
temp = merge(temp, counties_with_results, by.x="id", by.y="NAME", all.x=T, all.y=F)
head(temp)
ggplot(temp, aes(x=long, y=lat, group=group))+
  geom_polygon(aes(fill=pct_preterm), color="grey")+
  scale_fill_gradient(name="Percent Preterm", limits=c(0,25), low="white", high="red")+
  theme_map()


# Plot w spplot
#spplot(counties_with_results, counties_with_results$pct_preterm)

