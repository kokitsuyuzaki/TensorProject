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

awk 'NR==1 || FNR!=1' "data/"*"/"$1"mer_plasmid.csv" >> "data/"$1"mer_plasmid.csv"
