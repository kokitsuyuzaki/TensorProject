source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
infile4 <- args[4]
outfile1 <- args[5]
outfile2 <- args[6]
outfile3 <- args[7]

# Load
load(infile1)
allgene <- read_xlsx(infile2, sheet="allgene")$genename
deg_plsda1 <- read_xlsx(infile2, sheet="deg")$genename
deg_plsda2 <- read_xlsx(infile3, sheet="deg")$genename
deg_plsda3 <- read_xlsx(infile4, sheet="deg")$genename

# EnrichR
setEnrichrSite("FlyEnrichr")
dbs <- listEnrichrDbs()

# Plot (Component 2)
enriched1 <- enrichr(deg_plsda1, dbs)

# Plot (Component 3)
enriched2 <- enrichr(deg_plsda2, dbs)

# Plot (Component 4)
enriched3 <- enrichr(deg_plsda3, dbs)

save("")
