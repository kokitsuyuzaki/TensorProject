source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile1 <- commandArgs(trailingOnly=TRUE)[2]
outfile2 <- commandArgs(trailingOnly=TRUE)[3]
outfile3 <- commandArgs(trailingOnly=TRUE)[4]

# Loading
edges <- fread(infile, header=FALSE, colClasses=rep("character", 2))
edges <- as.matrix(edges)

# EdgeList -> Bipartite Graph
g <- graph.data.frame(edges, directed=FALSE)
V(g)$type <- V(g)$name %in% edges[,2]

# Bipartite Graph -> Incidence Matrix
g <- as_incidence_matrix(g)

# Incidence Matrix -> Matrix
counts <- as.matrix(g)

# Save
write.table(counts, file=outfile1,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(rownames(counts), file=outfile2,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(colnames(counts), file=outfile3,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
