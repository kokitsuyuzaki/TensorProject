source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Load
load(infile)

# ggplot
df$Rank <- str_sub(paste0("0", df$Rank), start = -2)
g <- ggplot(df, aes(x=Rank, y=Log10_TestRecError, group=Rank))
g <- g + geom_boxplot()
g <- g + stat_summary(fun = median, geom = "line",
	aes(group = 1), col = "red")
g <- g + labs(x = "rank", y="log10 (Reconstruction Error)")

# Save
ggsave(outfile, g, dpi=120, width=10, height=10)
