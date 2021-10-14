source("src/functions.R")

args <- commandArgs(trailingOnly = TRUE)

nmf_method <- args[1]
wordsize <- as.numeric(args[2])
r <- as.numeric(args[3])
outfile <- args[4]
file <- paste0("output/", nmf_method, "/", wordsize, "mer_", r, ".RData")
hostfile <- paste0("data/", wordsize, "mer_host.csv")
plasmidfile <- paste0("data/", wordsize, "mer_plasmid.csv")

# file loading
print("load")
host <- read.csv(hostfile, row.names=1)
plasmid <- read.csv(plasmidfile, row.names=1)
host <- as.matrix(host)
plasmid <- as.matrix(plasmid)
truepairs <- read.delim("data/truepairs.txt", header=FALSE, sep="|")[,c(4,7)]
truepairs <- paste(truepairs[,1], truepairs[,2])
load(file)

# Similarity Matrix
if(nmf_method == "nmf_similarity"){
    print("sim (1/3)")
    sim1 <- einsum('ij,jk->ik', plasmid, out$U)
    print("sim (2/3)")
    sim2 <- einsum('jk,lj->kl', out$U, host)
    print("sim (3/3)")
    sim <- einsum('ik,kl->li', sim1, sim2)
}else{
    print("sim (1/3)")
    sim1 <- einsum('ij,jk->ik', plasmid, out$W)
    print("sim (2/3)")
    sim2 <- einsum('jk,lj->kl', out$W, host)
    print("sim (3/3)")
    sim <- einsum('ik,kl->li', sim1, sim2)
}

# Transformation
print("transformation")
score <- as.vector(unlist(sim))
names(score) <- as.vector(outer(rownames(host), rownames(plasmid), paste))

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
