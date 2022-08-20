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

cd data

wget http://g86.dbcls.jp.s3-website-ap-northeast-1.amazonaws.com/data.tgz
tar -xzvf data.tgz
