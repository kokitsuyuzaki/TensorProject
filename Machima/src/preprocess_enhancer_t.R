source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile1 <- commandArgs(trailingOnly=TRUE)[2]
outfile2 <- commandArgs(trailingOnly=TRUE)[3]
outfile3 <- commandArgs(trailingOnly=TRUE)[4]

# Loading
bed <- fread(infile, header=FALSE, colClasses=rep("character", 4))

# Preprocessing
bed[, new := do.call(paste, c(.SD, sep="_")), .SDcols=1:3]
bed <- bed[V4 != "."]
bed <- as.matrix(bed[, 5:4])

# Remove ,
left <- unlist(apply(bed, 1, function(x){
    rep(x[1], length(strsplit(x[2], ",")[[1]]))
}))
right <- unlist(apply(bed, 1, function(x){
    strsplit(x[2], ",")[[1]]
}))
edges <- cbind(left, right)

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
