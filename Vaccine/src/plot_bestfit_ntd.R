source("src/Functions.R")

# Parameter
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile <- commandArgs(trailingOnly=TRUE)[2]

# Load
load(infile)
load("data/VaccineTensor.RData")

# Preprocess
symptom_patterns <- out$A[[1]]
day_patterns <- out$A[[2]]
ma <- max(nrow(symptom_patterns), nrow(day_patterns))

png(file=outfile, width=5000, height=3500)
par(ps=35)
layout(cbind(1:ma, (ma+1):(2*ma)))
for(i in seq(nrow(symptom_patterns))){
	barplot(symptom_patterns[i,], main=paste0("Symptom module ", i),
		names.arg=dimnames(X@data)[[1]])
}
for(i in seq(nrow(day_patterns))){
	barplot(day_patterns[i,], main=paste0("Temporal module ", i),
		names.arg=dimnames(X@data)[[2]])
}
dev.off()
