# venn.R

install.packages("VennDiagram")
library(VennDiagram)

overrideTriple=TRUE
venn.plot <- draw.triple.venn(200, 100, 100, 20,10,10,4,c("First", "Second","Third"));
grid.draw(venn.plot);
grid.newpage();
