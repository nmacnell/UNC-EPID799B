# data.R
# handlers for importing/exporting data

# handler for importing data
w$import.csv <- function(h,...) {
  w$do.import <- function(h,...) {
    path <- svalue(w$importpath)
    obj <- svalue(w$dataname)
    path <- gsub("'","",path)
    # want to put result back into the global environment
    # TODO: make this not as sloppy
    assign(obj,read.csv(file=path),env=globalenv())
    cat("\nImporting Data...\n")
    dispose(w$import)
  }
  w$import <- gwindow("Import CSV",visible=FALSE                        )
  w$importg <-ggroup(horizontal=FALSE,container=w$import)
  w$importpath <- gfilebrowse("Select .csv file",container=w$importg)
  w$dataentry <- ggroup(horizontal=TRUE,container=w$importg)
  w$dataname <- gedit("newdata",container=w$dataentry)
  w$label <- glabel("Imported Dataset Name",container=w$dataentry)
  w$import.go <- gbutton("Import",container=w$importg,handler=w$do.import)
  visible(w$import) <- TRUE
}

w$exportCsvHandler <- function(h,...) {
  w$exportDo <- function(h,...) {
    path <- gsub("'","",svalue(w$exportPath))
    write.csv(get(svalue(w$explorer)),file=path)
    dispose(w$exportDialog)
  }
  w$exportDialog <- gwindow("Export as CSV",visible=FALSE)
  w$exportGroup <- ggroup(horizontal=FALSE,container=w$exportDialog)
  w$exportPath <- gfilebrowse("Select filename",container=w$exportGroup)
  w$exportGo <- gbutton("Export",container=w$exportGroup,handler=w$exportDo)
  visible(w$exportDialog) <- TRUE
}
