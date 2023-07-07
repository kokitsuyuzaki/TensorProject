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

tmpfile1=$(mktemp)
tmpfile2=$(mktemp)

cat $1 | awk -F "," '{print $1}' > $tmpfile1

awk 'NR==1 || FNR!=1' "output/mcd_mahalanobis_distance/"*"/"$2"mer.csv" >> $tmpfile2

paste -d, $tmpfile1 $tmpfile2 > "output/mcd_mahalanobis_distance/"$2"mer.csv"
