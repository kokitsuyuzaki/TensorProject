source("src/Functions.R")

# Arguments
infile <- commandArgs(trailingOnly=TRUE)[1]
outfile1 <- commandArgs(trailingOnly=TRUE)[2]
outfile2 <- commandArgs(trailingOnly=TRUE)[3]
outfile3 <- commandArgs(trailingOnly=TRUE)[4]
outfile4 <- commandArgs(trailingOnly=TRUE)[5]
outfile5 <- commandArgs(trailingOnly=TRUE)[6]
outfile6 <- commandArgs(trailingOnly=TRUE)[7]

# Loading
read_excel(infile) -> data

# Meta data
data %>% select(all_of(metadata_name)) -> metadata

# Tensor construction
map(days, function(x){data %>% select(contains(paste0(x, symptoms)))}) %>%
    abind(along=3) -> vaccine_tensor

# Filtering
vaccine_tensor %>% is.na %>% einsum('ijk->i', .) %>% `<`(thr) %>% which -> subjects
vaccine_tensor[subjects,,] %>% as.tensor -> vaccine_tensor
metadata[subjects, ] -> metadata

# NA => 0
vaccine_tensor@data[is.na(vaccine_tensor@data)] <- 0

# Dimension name
dimnames(vaccine_tensor@data) <- list(subjects=subjects, symptoms=symptoms, days=days)

# Save CSV file
write_csv(metadata, outfile1)

# Save text files
write.table(subjects, outfile2, row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(symptoms, outfile3, row.names=FALSE, col.names=FALSE, quote=FALSE)
write.table(days, outfile4, row.names=FALSE, col.names=FALSE, quote=FALSE)

# Save Python binary file
np <- import("numpy")
np$save(outfile5, r_to_py(vaccine_tensor@data)) # Type np.load() in Python

# Save R binary file
save(vaccine_tensor, file=outfile6)
