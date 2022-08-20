# Parameter
params <- commandArgs(trailingOnly=TRUE)
infiles <- params[-length(params)]
outfile <- params[length(params)]

# Loading
out <- unique(unlist(lapply(infiles, function(x){
	read.delim(x, header=FALSE)
})))

# Save
write.table(out, outfile, row.names=FALSE, col.names=FALSE, quote=FALSE)
