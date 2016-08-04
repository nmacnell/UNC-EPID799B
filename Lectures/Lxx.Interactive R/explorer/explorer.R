# explorer.R
# example of a GTK2-based GUI using gwidgets
# make sure to install gtk2 on your computer first

# this file includes layouts for the main window.
# see hander files for individual features.

# what should the main display look like?

# install.packages("gWidgetsRGtk2",dep=TRUE)
 require(gWidgets)
options("guiToolkit"="RGtk2")

setwd("/home/nat/LearnR/explorer") 

# make an environment to keep things from clogging user space
w <- new.env()
# source all of the handlers
source("file.R") 
source("data.R") 
source("summary.R")

# define default handler (nothing)
w$nothing <- function(h,...) {
  # do nothing
  gmessage("Coming soon!")
}

# main window
w$main <- gwindow("Data Explorer",visible=FALSE)

# prepare drop-down menu action lists
w$file.actions <- list(open=gaction("Open Project",icon="open",handler=w$loadHandler),
                     save=gaction("Save Project",icon="save",handler=w$saveHandler),
                     quit=gaction("Quit",icon="quit",handler=function(h,...) dispose(w$main)))
w$data.actions <- list(import=gaction("Import .csv",icon="open",handler=w$import.csv),
                     export=gaction("Export .csv",icon="save",handler=w$exportCsvHandler))
w$clean.actions <- list(fix.missing=gaction("Fix Missing",handler=w$nothing))
w$summary.actions <- list(univariate=gaction("Univariate",handler=w$nothing))

# build horizontal menu bar items
w$menubar.list <- list(File=w$file.actions, Data=w$data.actions, Clean=w$clean.actions,Summary=w$summary.actions)
gmenu(w$menubar.list,cont=w$main)

# build variable browser 
w$explorer <- gvarbrowser(container=w$main)
 
# Browser Features

 # rename/copy
w$rename.do <- function(h,...) {
  o <- svalue(w$explorer)
  n <- svalue(w$rename.text)
  assign(n,get(o),env=globalenv())
  dispose(w$rename.dialog)
  rm(o,envir=globalenv())
} 

w$copy.do <- function(h,...) {
   o <- svalue(w$explorer)
   n <- svalue(w$rename.text)
   assign(n,get(o),env=globalenv())
   dispose(w$rename.dialog)
} 
 
w$rename <- function(h,...) {
  # pop up rename window
  w$rename.dialog <- gwindow("Rename")
  w$rename.text <- gedit(container=w$rename.dialog,initial.msg=svalue(w$explorer))
  svalue(w$rename.text) <- svalue(w$explorer)
  w$rename.go <- gbutton("Rename",container=w$rename.dialog,handler=w$rename.do) 
} 
 
w$copy <- function(h,...) {
   # pop up rename window
   w$rename.dialog <- gwindow("Copy")
   w$rename.text <- gedit(container=w$rename.dialog,initial.msg=svalue(w$explorer))
   svalue(w$rename.text) <- svalue(w$explorer)
   w$rename.go <- gbutton("Copy",container=w$rename.dialog,handler=w$copy.do) 
} 

# add right-click popup menus on main browser
w$rightclick.list <- list(rename=gaction("Rename",handler=w$rename),
                         copy=gaction("Copy",handler=w$copy))
add3rdMousePopupmenu(w$explorer, w$rightclick.list, action=NULL)
 
# render window
visible(w$main) <- TRUE