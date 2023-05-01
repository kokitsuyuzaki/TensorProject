source("src/Functions.R")

args <- commandArgs(trailingOnly = TRUE)
infile <- args[1]
outfile1 <- args[2]
outfile2 <- args[3]

# Load
load(infile)

# Preprocessing
melted_logcount <- melt(cor(logcount))
logcount_group <- sapply(LETTERS[1:5], function(x){rowMeans(logcount[, grep(x, colnames(logcount))])})
melted_logcount_group <- melt(cor(logcount_group))

# Plot
g1 <- ggplot(melted_logcount, aes(x=Var1, y=Var2, fill=value))
g1 <- g1 + scale_fill_viridis_c()
g1 <- g1 + geom_tile()
ggsave(file=outfile1, plot=g1, width=9, height=9)

g2 <- ggplot(melted_logcount_group, aes(x=Var1, y=Var2, fill=value))
g2 <- g2 + scale_fill_viridis_c()
g2 <- g2 + geom_tile()
ggsave(file=outfile2, plot=g2, width=5, height=5)
