source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
outfile1 <- commandArgs(trailingOnly=TRUE)[4]
outfile2 <- commandArgs(trailingOnly=TRUE)[5]
outfile3 <- commandArgs(trailingOnly=TRUE)[6]

# Loading
counts <- read.csv(infile1, header=FALSE)
region_names <- read.csv(infile2, header=FALSE)
label <- unlist(read.delim(infile3, header=FALSE))

# Pseudo Bulk
res.pseudobulk <- apply(ratios, 1, function(x){
    .pseudoBulk(x[1:2], celltypes, counts, label)
})

new_label <- apply(ratios, 1, function(x){
    paste0(c(celltypes[1], celltypes[2], x[1], x[2]), collapse="_")
})

# Save
write.table(res.pseudobulk, file=outfile1,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(region_names, file=outfile2,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
write.table(new_label, file=outfile3,
    row.names=FALSE, col.names=FALSE, quote=FALSE, sep=",")
