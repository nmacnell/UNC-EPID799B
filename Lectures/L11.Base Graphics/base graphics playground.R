###################################################################
# Plots in base R
# Mike Dolan Fliss. Spring 2016
###################################################################

#### Read file  ############
setwd("D:/User/Dropbox/EPID799B 2016/Data/NC Births/2012/")
births = read.table("births2012.tab", sep="\t", stringsAsFactors = F, header = T)
names(births) = tolower(names(births))


### Sidenote on writing files ###
write.csv(head(births), "birth-head.csv", row.names = F)
shell.exec("birth-head.csv") #opens a file. may only work on PC.
write.table(head(births), "clipboard", sep="\t") #Send data to clipboard as a tab-delim'ed table


#### Base Graphics ############
# http://www.statmethods.net/graphs/index.html 
# For speed, today, let's do this.

rows_to_pick = sample.int(nrow(births), 1000); 
births = births[rows_to_pick,]



### histograms
hist(births$mdif)

births$mdif[births$mdif %in% c(88,99)] = NA
hist(births$mdif)
hist(births$mdif, breaks=3, col="blue") #dumb breaks


### Simple X-Y chart
plot(births$mdif, births$wksgest) 

table(births$wksgest)
births$wksgest[births$wksgest %in% c(88,99)] = NA
plot(births$mdif, births$wksgest) 

# pch possibilities: http://www.statmethods.net/advgraphs/parameters.html 
plot(jitter(births$mdif), jitter(births$wksgest), pch=".") #overplotting tricks
# NOTE: alpha would be nice here. We'll see some better options for overplotting later, and definitely in ggplot
abline(lm(wksgest ~ mdif, data=births), lty=5, col="blue")
title("Weeks gestation vs. month prenatal care began") 
#^ Can stick other stuff in title()

plot(jitter(births$mdif), jitter(births$wksgest), pch=".", 
     main="Weeks gestation vs. month PNC began", xlab="month PNC began", ylab="gestational age at birth") 


### Model objects
lm.gest = lm(wksgest ~ mdif, data=births) #Use predict(lm.gest) to get predictions.
#plot(lm.gest)
#See http://stats.stackexchange.com/questions/58141/interpreting-plot-lm
par(mfrow=c(2,2)); plot(lm.gest); par(mfrow=c(1,1))


### Dotchart
library(dplyr)
#We'll import names for these later...
#county_births = births %>% select(cores, wksgest) %>% group_by(cores) %>% summarise(n=n()) %>% arrange(n) %>% top_n(20)
dotchart(county_births$n, labels=county_births$cores)
temp = head(table(births$cores), 20)
dotchart(as.numeric(temp), labels=names(temp))

### Density
d = density(births$wksgest[births$cigdur=="Y"], bw = .5, na.rm=T); d
plot(d, col="blue", main="Density") #Note - takes a density object and plots it. Like plot(lm)


### Bar plots
barplot(head(table(births$cores), 20))
births$cigdur[births$cigdur=="U"] = NA
smoke_table = table(births$cigdur, births$wksgest)
barplot(smoke_table, col=c("grey", "red"), legend=rownames(smoke_table))

smoke_table_prop = prop.table(table(births$cigdur, births$wksgest), 1) #Create proportion table
barplot(smoke_table_prop, col=c("grey", "red"), legend=rownames(smoke_table), beside = T)
#This would be better as a density graph...wait for ggplot!

### Boxplot
boxplot(wksgest~cigdur, births, col=c("grey", "red"), main="Garrish boxplot")


### Saving 
# really, use ggplot and ggsave().
png("mygarrishgraph.png") #or pdf(), jpeg(), etc.
boxplot(wksgest~cigdur, births, col=c("grey", "red"), main="Garrish boxplot")
dev.off()
shell.exec("mygarrishgraph.png") 

###################################
#### Advanced Graphics ############
# http://www.statmethods.net/advgraphs/index.html
# I usually start with this (actually, ggpairs from ggAlly): 
library(car)
names(births)
vars_to_pick = c("mage", "mdif", "wksgest")
scatterplotMatrix(births[,vars_to_pick]) 


