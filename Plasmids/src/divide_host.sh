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

infile=`ls data/$1/*.gz`

export JULIA_DEPOT_PATH="/usr/local/julia/"
julia src/divide_host.jl $infile $2
