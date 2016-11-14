extract.graphs <- function(net, cut, level = 2) {
  neighbors <- c(); l <- 1
  for (l in 1:level) {
    ifelse(l==1, neighbors <- c(get.neighborhood(net, cut), cut),
           neighbors <- c(neighbors,
                          unlist(lapply(neighbors, function(x) {
                            get.neighborhood(net, x)}))))
    neighbors <- unique(neighbors)
    l <- l + 1
  }
  subg <- unique(neighbors)
  subgraph <- get.inducedSubgraph(net, subg)
  return(list(cut = cut, subgraph = subgraph))
}
