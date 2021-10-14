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

IFS=$'\n'
rm -rf $2

if [ -s $1 ]; then
    HEADER1=(`grep ">" $1 | awk '{print $1}' | sed "s|>||"`)
    for i in ${HEADER1[@]}; do
        echo $3"|||"$i >> $2
    done
fi

touch $2
