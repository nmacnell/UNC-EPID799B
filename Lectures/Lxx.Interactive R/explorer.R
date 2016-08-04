# explorer.R
# example of a GTK2-based GUI using gwidgets
# make sure to install gtk2 on your computer first

# install.packages("gWidgetsRGtk2",dep=TRUE)
 require(gWidgets)
options("guiToolkit"="RGtk2")

nothing <- function() {}

main <- gwindow("Data Explorer",visible=FALSE)

# prepare drop-down menu action lists
file.actions <- list(open=gaction("Open Project",icon="open",handler=nothing),
                     save=gaction("Save Project",icon="save",handler=nothing),
                     quit=gaction("Quit",icon="quit",handler=function(...) dispose(main)))
data.actions <- list(import=gaction("Import Data",icon="open",handler=nothing),
                     export=gaction("Export Data",icon="save",handler=nothing))
clean.actions <- list(fix.missing=gaction("Fix Missing",handler=nothing))
summary.actions <- list(univariate=gaction("Univariate",handler=nothing))

# build horizontal menu bar items
menubar.list <- list(File=file.actions, Data=data.actions, Clean=clean.actions,Summary=summary.actions)
gmenu(menubar.list,cont=main)

# render window
visible(main) <- TRUE