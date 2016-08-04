# extras.R
# extra code removed from the main line

# add tree of available data (start with tutorial)
object.offspring <- function(path,user.data=NULL) {
  objects <- data.frame(Name=ls(globalenv()))
  return(objects)
}

# only dig deeper into data frames
object.hasOffspring <- function(children,user.data=NULL,...) {
  return(FALSE) # don't dig for now
}

# add data frame to display
# TODO: Make tree update
tree <- gtree(offspring=object.offspring,hasOffspring=object.hasOffspring,icon.FUN=icon.FUN,container=main)
# add data notebook display
# notebook <- gnotebook(tab.pos=3,closebuttons=TRUE,container=main)

# add tree behavior
addHandlerDoubleclick(tree, handler=function(h,...) {
  print(svalue(h$obj)) # the key
  print(h$obj[]) # vector of keys
})


univariate <- function()
  gmessage("hey")
x <- CO2$uptake
x

summary(x)


# code for file broswer
offspring <- function(path,user.data=NULL) {
  if(length(path) > 0)
    directory <- paste(getwd(),"/",paste(path,sep="/", collapse=""),sep="",collapse="")
  else
    directory <- getwd()
  tmp <- file.info(dir(path=directory))
  files <- data.frame(Name=rownames(tmp), isdir=tmp[,2], size=as.integer(tmp[,1]))
  return(files)
}

hasOffspring <- function(children,user.data=NULL, ...) {
  return(children$isdir)
}

icon.FUN <- function(children,user.data=NULL, ...) {
  x <- rep("file",length= nrow(children))
  x[children$isdir] <- "directory"
  return(x)
}

# create manual file browser
#gtree(offspring, hasOffspring, icon.FUN = icon.FUN,
#      container=gwindow(getwd()))


getwd()
data(PlantGrowth)
write.csv(PlantGrowth,"growth.csv")
rm(PlantGrowth)
