# plotstagram.R

# makes quick summaries of csv data files using a graphical interface
# look at the gtk.R example first to see how everything works.

# requires: gWidgetsRGtk2 package (requires restart)
library(gWidgetsRGtk2)


### Define the handlers
# these determine what happens when the user presses a button. 

browse <- function(h, ...) {
	
	# ask the user to select a file
	svalue(file.name) <- gfile()
	
	# load the variables from the dataset
	dataset <- read.csv(svalue(file.name))

	# push dataset out to the .program environment
	assign("dataset",dataset,envir=.program)

	# look up the variable names
	var.names <- names(dataset)

	# add each name to the variable name selector box
	for(i in 1:length(var.names)) {

		# replace each element of the data.names combobox
		# with the corresponding variable name in the dataset
		# the "[<-" is actually the name a a function!
		# It looks terrible, but giving it this name actually
		# lets you access elements of this list using []
		"[<-"(data.names, i, value=var.names[i])

	}

}

select.var <- function(h, ...) {
	
	# load the dataset from the .program environment
	dataset <- get("dataset",envir=.program)
	
	variable <- dataset[,svalue(data.names)]

	# calculate summary statistics
	df <- summary(variable)

}

# set up environment (allows all functions to pass data to each other)
.program <- new.env()

# create the main window
window <- gwindow("Plotstagram",visible=TRUE)

# create layout groups
main.group <- ggroup(horizontal=FALSE,container=window)
top.bar <- ggroup(horizontal=TRUE,container=main.group)
boxes <- ggroup(horizontal=TRUE,container=main.group)
left.box <- ggroup(horizontal=FALSE,container=boxes)
right.box <- ggroup(horizontal=FALSE,container=boxes)

# create a a file dialog
file.label <- glabel("Enter .csv File:",container=top.bar)
file.name <- gedit("Filename",container=top.bar)
file.choose <- gbutton("Browse...",container=top.bar,handler=browse)

# create variable selector
	data.label <- glabel("Variable:",container=left.box)
	data.names <- gcombobox("Select Dataset First",
		container=left.box,handler=select.var,selected=1)

# Create a table of data to display
df <- data.frame(var=c("Select","Data"))
summary.table<- gtable(df,container=right.box,expand=TRUE)




