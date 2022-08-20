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

mkdir -p data/bulkChIPseq
cd data/bulkChIPseq

curl -O https://zenodo.org/record/6622331/files/$1.bed.sorted.$2.bin
