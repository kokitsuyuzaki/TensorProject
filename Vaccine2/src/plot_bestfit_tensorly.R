source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
infile3 <- commandArgs(trailingOnly=TRUE)[3]
outfile <- commandArgs(trailingOnly=TRUE)[4]

# Load
best_trial <- read.table(infile1)
infile1_1 <- paste0("output/tensorly/bestfit_rank/", best_trial, "/factor2.csv")
infile1_2 <- paste0("output/tensorly/bestfit_rank/", best_trial, "/factor3.csv")
symptom_patterns <- t(read.csv(infile1_1, header=FALSE))
day_patterns <- t(read.csv(infile1_2, header=FALSE))
symptoms_names <- unlist(read.table(infile2))
days_names <- unlist(read.table(infile3))

# Preprocess
ma <- max(nrow(symptom_patterns), nrow(day_patterns))

png(file=outfile, width=5000, height=3500)
par(ps=35)
layout(cbind(1:ma, (ma+1):(2*ma)))
for(i in seq(nrow(symptom_patterns))){
	barplot(symptom_patterns[i,], main=paste0("Symptom module ", i),
		names.arg=symptoms_names)
}
for(i in seq(nrow(day_patterns))){
	barplot(day_patterns[i,], main=paste0("Temporal module ", i),
		names.arg=days_names)
}
dev.off()
