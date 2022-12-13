source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Load
df <- read.csv(infile)
df <- pivot_longer(df, cols=seq(ncol(df)))
colnames(df) <- c("Rank", "TestRecError")

# ggplot
g <- ggplot(df, aes(x=Rank, y=TestRecError, group=Rank))
g <- g + geom_boxplot()
g <- g + stat_summary(fun = median, geom = "line",
	aes(group = 1), col = "red")
g <- g + labs(x = "rank", y="Reconstruction Error")

# Save
ggsave(outfile, g, dpi=120, width=10, height=10)
