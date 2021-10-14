source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

previous_method <- args[1]
wordsize <- as.numeric(args[2])
outfile <- args[3]
file <- paste0("output/", previous_method, "/", wordsize, "mer.csv")

# file loading
print("read.csv")
truepairs <- read.delim("data/truepairs.txt", header=FALSE, sep="|")[,c(4,7)]
truepairs <- paste(truepairs[,1], truepairs[,2])
distances <- read.csv(file, row.names=1, header=TRUE)

# Transformation
print("transformation")
score <- as.vector(1 / unlist(distances))
names(score) <- as.vector(outer(rownames(distances), colnames(distances), paste))

# ROC
actual <- score
actual[] <- 0
print("intersect")
target <- intersect(truepairs, names(score))
actual[target] <- 1
print("ROC")
out <- ROC(score, actual)

# Output
print("save")
save(out, file=outfile)
