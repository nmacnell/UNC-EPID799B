#######################
# ggplot I            #
# EPID 799B           #
# Fall, 2016          #
# Xiaojuan Li         #
#######################

### 0. read in dataset ##
setwd("C:/Users/xli.AD/Dropbox/EPID799B 2016/Data/NC Births/2012")
births = read.table("births2012.tab", sep="\t", stringsAsFactors = F, header = T)
names(births) = tolower(names(births))

head(births)

### take a random sample
births1 <- births[sample.int(nrow(births), 1000),]
births1$mdif[births1$mdif %in% c(88,99)] <- NA
births1$mage[births1$mage ==99] <- NA
births1$cigdur[births1$cigdur=="U"] <- NA

### load the package
library(ggplot2)

### a. simple density plot
ggplot(data=births1, aes(x=mage)) + geom_density()
ggplot(data=births1, aes(x=mage)) + geom_density(na.rm=TRUE)

### b. simple histogram
ggplot(births1, aes(mage)) + geom_histogram()
ggplot(births1, aes(mage)) + geom_histogram(fill="blue", na.rm=TRUE)
ggplot(births1, aes(mage)) + geom_histogram(fill="blue", alpha=0.3, binwidth=0.5, na.rm=TRUE) 

### c. stratified by a group variable
ggplot(na.omit(births1), aes(mage, fill=cigdur)) + geom_density(alpha=0.5)
ggplot(na.omit(births1), aes(mage)) + geom_density(aes(fill=cigdur), alpha=0.5)
ggplot(na.omit(births1), aes(mage)) + geom_density(aes(fill=cigdur, alpha=0.5))

ggplot(births1, aes(mage, fill=as.factor(sex))) + geom_histogram(alpha=0.5, binwidth=0.5,
                                                                   position = "dodge")

### d. faceting
ggplot(na.omit(births1), aes(mage, fill=cigdur)) + geom_histogram(alpha=0.8, binwidth=0.6,
                                                                  position = "dodge") + 
  facet_wrap(~sex) # specify ncol to change the layout
                                                                

### e. overlaying plots
a <- ggplot(births1, aes(mdif, wksgest)) + geom_point(color="blue", position="jitter")  
a + geom_smooth(method="lm", col="red") +
  ggtitle("Weeks gestation vs. month PNC began") +
  xlab("month PNC began") +
  ylab("gestational age at birth") +
  theme_bw()

### f. changing shape, size and linetype
library(splines)
library(MASS)
library(scales)
ggplot(na.omit(births1), aes(mdif, wksgest, shape=as.factor(sex))) + 
  geom_point(size=2.5, alpha=0.8, na.rm=TRUE, position="jitter") +
  scale_shape_manual(values=c(1,4)) +
  geom_smooth(aes(color=as.factor(sex), linetype=as.factor(sex)), method = "lm", 
                  formula = y ~ ns(x, 4), na.rm=TRUE) +                       
  scale_colour_brewer(palette="Set1") +
  scale_x_continuous(breaks=pretty_breaks()) +
  theme_bw() + 
  facet_wrap(~cigdur)   # faceting 

# change point size based on the inverse of var6
ggplot(data=exdat, aes(x=var4,y=var5, shape=var2)) + 
  geom_point(aes(size=1/var6, alpha=0.5), na.rm=TRUE) +
  geom_smooth(aes(color=var2))

### g. stats - changing smoothing method
library(splines)
library(MASS)
library(scales)
b<- ggplot(births1, aes(mdif, wksgest, shape=as.factor(sex))) + 
  geom_point(size=2.5, alpha=0.8, na.rm=TRUE, position="jitter") +
  scale_shape_manual(values=c(1,4)) +
  scale_colour_brewer(palette="Set1") +
  scale_x_continuous(breaks=pretty_breaks()) +
  theme_bw() 

b + geom_smooth()  
b + geom_smooth(aes(color=as.factor(sex))) 
b + geom_smooth(aes(color=as.factor(sex), method ='lm'))               
b + geom_smooth(aes(color=as.factor(sex), linetype=as.factor(sex)), method = "lm", 
              formula = y ~ ns(x, 4), na.rm=TRUE)                        


### h. change color
ggplot(births1, aes(mdif, wksgest, shape=as.factor(sex))) + 
  geom_point(size=2.5, alpha=0.8, na.rm=TRUE, position="jitter") +
  scale_shape_manual(values=c(1,4)) +
  geom_smooth(aes(color=as.factor(sex), linetype=as.factor(sex)), method = "lm", 
              formula = y ~ ns(x, 4), na.rm=TRUE) +                       
  scale_x_continuous(breaks=pretty_breaks()) +
  scale_colour_brewer(palette="Set1")

### i. annotation
ggplot(births1, aes(mdif, wksgest)) + geom_point(color="blue", position="jitter") + 
  geom_smooth(method="lm", col="red") +
  scale_x_continuous(breaks=pretty_breaks()) +
  ggtitle("Weeks gestation vs. month PNC began") +
  xlab("month PNC began") +
  ylab("gestational age at birth") +
  theme_bw()


### j. changing legend labels
ggplot(births1, aes(mdif, wksgest, shape=as.factor(sex), color=as.factor(sex))) + 
  geom_point(size=2.5, alpha=0.8, na.rm=TRUE, position="jitter") +
  scale_colour_manual("Sex", 
                      values=c("blue","green"),
                     labels=c("Male", "Female")) +  
  scale_shape_manual("Sex", 
                     values=c(1,4), labels=c("Male", "Female")) +
  scale_x_continuous(breaks=pretty_breaks()) +
  ggtitle("Weeks gestation vs. month PNC began") +
  xlab("month PNC began") +
  ylab("gestational age at birth") +
  theme_bw()

#option 2
births1$sex.f <- factor(births1$sex, levels=c(1,2), labels=c("Male", "Female"))
ggplot(births1, aes(mdif, wksgest, shape=sex.f, color=sex.f)) + 
  geom_point(size=2.5, alpha=0.8, na.rm=TRUE, position="jitter") +
  scale_color_discrete("Sex")   +
  scale_shape_manual("Sex", 
                     values=c(1,4)) +
  scale_x_continuous(breaks=pretty_breaks()) +
  ggtitle("Weeks gestation vs. month PNC began") +
  xlab("month PNC began") +
  ylab("gestational age at birth") +
  theme_bw()
