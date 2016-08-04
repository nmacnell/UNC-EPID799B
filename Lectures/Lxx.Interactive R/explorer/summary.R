# summary.R
# R script to perform statistical summaries

# unnivariate statistics
w$uniHandler <- function(h,...) {
  w$uniDialog <- gwindow("Summary",visible=TRUE,width=800,height=600)
  w$uniGroup <- ggroup(container=w$uniDialog)
  w$Gnb <- ggraphicsnotebook(container=w$uniGroup, label="Density")
  plot(density(CO2$uptake))
  # TODO: Add more plots
  ggraphics(container=w$Gnb)
  par(mar=c(0,0,0,0))
  hist(CO2$uptake)
  ggraphics(container=w$Gnb)
  par(mar=c(0,0,0,0))
  plot(CO2$uptake)
}

w$uniHandler()