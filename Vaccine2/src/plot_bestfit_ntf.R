source("src/Functions.R")

# Parameter
infile1 <- commandArgs(trailingOnly=TRUE)[1]
infile2 <- commandArgs(trailingOnly=TRUE)[2]
outfile <- commandArgs(trailingOnly=TRUE)[3]

# Load
load(infile1)
load(infile2)

# Preprocess
symptom_patterns <- out$A[[2]]
day_patterns <- out$A[[3]]
ma <- max(nrow(symptom_patterns), nrow(day_patterns))

png(file=outfile, width=5000, height=3500)
par(ps=35)
layout(cbind(1:ma, (ma+1):(2*ma)))
for(i in seq(nrow(symptom_patterns))){
	barplot(symptom_patterns[i,], main=paste0("Symptom module ", i),
		names.arg=dimnames(vaccine_tensor@data)[[2]])
}
for(i in seq(nrow(day_patterns))){
	barplot(day_patterns[i,], main=paste0("Temporal module ", i),
		names.arg=dimnames(vaccine_tensor@data)[[3]])
}
dev.off()
