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

wget https://github.com/eiryo-kawakami/Vaccine_Tensor_2022_code/raw/main/data/CUH_SmartDR.xlsx -P data
