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

mkdir -p data/scChIPseq
cd data/scChIPseq

wget https://www.dropbox.com/s/eourouy8wmpiegu/Jurkat_Ramos.zip

curl -L https://www.dropbox.com/s/eourouy8wmpiegu/Jurkat_Ramos.zip?dl=0 > Jurkat_Ramos.zip
unzip Jurkat_Ramos.zip
