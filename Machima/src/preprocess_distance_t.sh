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

cat $1 | awk -F ' ' '{print $1"_"$2"_"$3"\t"$4}' | awk 'a[$0]++{print}' > $2