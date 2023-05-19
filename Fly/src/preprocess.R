source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile1 <- args[1]
infile2 <- args[2]
infile3 <- args[3]
outfile <- args[4]

# Load
count <- as.matrix(read.delim(infile1, header=TRUE, row.names=1))
rpkm <- as.matrix(read.delim(infile2, header=TRUE, row.names=1))
label <- as.matrix(read.delim(infile3, header=FALSE, row.names=1))

count <- count[sort(rownames(count)), ]
rpkm <- rpkm[sort(rownames(rpkm)), ]

# Convert
logcount <- log10(count + 1)
logrpkm <- log10(rpkm + 1)
count.deg <- count[deg.genes, ]
rpkm.deg <- rpkm[deg.genes, ]
logcount.deg <- log10(count.deg + 1)
logrpkm.deg <- log10(rpkm.deg + 1)

# Dummy Variables
dummyY <- matrix(0, nrow=ncol(count), ncol=5)
rownames(dummyY) <- colnames(count)
colnames(dummyY) <- LETTERS[1:5]
dummyY[grep("A", colnames(count)), 1] <- 1
dummyY[grep("B", colnames(count)), 2] <- 1
dummyY[grep("C", colnames(count)), 3] <- 1
dummyY[grep("D", colnames(count)), 4] <- 1
dummyY[grep("E", colnames(count)), 5] <- 1

# Color Vector
col.group <- gsub("[0-9]", "", unlist(label[2, ]))
names(col.group) <- col.group
col.group[which(col.group == "A")] <- "#5E4FA2"
col.group[which(col.group == "B")] <- "#3288BD"
col.group[which(col.group == "C")] <- "#FDAE61"
col.group[which(col.group == "D")] <- "#F46D43"
col.group[which(col.group == "E")] <- "#9E0142"

PI <- as.numeric(unlist(label[3, ]))

col.pi <- smoothPalette(-PI, pal="RdBu")
names(col.pi) <- names(col.group)

# Save
save(count, logcount, count.deg, logcount.deg,
	rpkm, logrpkm, rpkm.deg, logrpkm.deg,
	label, dummyY, PI, col.group, col.pi, file=outfile)