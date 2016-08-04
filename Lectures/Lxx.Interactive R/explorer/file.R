# file.R
# handlers for saving and opening projects (as .RData)

# load built-in tutorial dataset
data(CO2)

# dialog to save workspace
w$saveHandler <- function(h,...) {
  w$saveDo <- function(h,...) {
    #TODO: append .RData if needed
    path <- gsub("'","",svalue(w$savePath))
    save.image(file=path)
    dispose(w$saveDialog)
  }
  w$saveDialog <- gwindow("Save Workspace As... (End in .RData)",visible=FALSE)
  w$saveGroup <-ggroup(horizontal=FALSE,container=w$saveDialog)
  w$savePath <- gfilebrowse("Select filename",container=w$saveGroup)
  w$saveGo <- gbutton("Save",container=w$saveGroup,handler=w$saveDo)
  visible(w$saveDialog) <- TRUE
}

# handler to load workspace
w$loadHandler <- function(h,...) {
  w$loadDo <- function(h,...) {
    #TODO: append .RData if needed
    filePath <- gsub("'","",svalue(w$loadPath))
    load(file=filePath, envir=globalenv())
    cat("loaded")
    dispose(w$loadDialog)
  }
  w$loadDialog <- gwindow("Load Workspace...",visible=FALSE)
  w$loadGroup <-ggroup(horizontal=FALSE,container=w$loadDialog)
  w$loadPath <- gfilebrowse("Select file",container=w$loadGroup)
  w$loadGo <- gbutton("Load",container=w$loadGroup,handler=w$loadDo)
  visible(w$loadDialog) <- TRUE
}