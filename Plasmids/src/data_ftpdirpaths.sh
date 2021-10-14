#!/bin/bash
#$ -l nc=4
#$ -p -50
#$ -r yes
#$ -q node.q

#SBATCH -n 4
#SBATCH --nice=50
#SBATCH --requeue
#SBATCH -p node03-06
SLURM_RESTART_COUNT=2

# List the FTP path (column 20) for the assemblies of interest
refseq_category="reference genome"
refseq_category="." # 15 reference genome # 14155 representative genome
organism_name="Mycoplasma.genitalium|Mycoplasma.pneumoniae"
organism_name="Escherichia coli"
organism_name="."
assembly_level="Complete Genome"

cat data/assembly_summary.txt | awk -F "\t" '$5 ~ /'"$refseq_category"'/ && $8 ~ /'"$organism_name"'/ && $11=="latest" && $12 ~ /'"$assembly_level"'/ {print $0}' | cut -f8,9,12 | wc -l
cat data/assembly_summary.txt | awk -F "\t" '$5 ~ /'"$refseq_category"'/ && $8 ~ /'"$organism_name"'/ && $11=="latest" && $12 ~ /'"$assembly_level"'/ {print $20}' > data/ftpdirpaths.txt
