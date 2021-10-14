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
rm -rf $3

if [ -s $1 ]; then
    if [ -s $2 ]; then
        HEADER1=(`grep ">" $1 | awk '{print $1}' | sed "s|>||"`)
        HEADER2=(`grep ">" $2 | awk '{print $1}' | sed "s|>||"`)
        for i in ${HEADER1[@]}; do
            for j in ${HEADER2[@]}; do
                echo $4"|||"$i"|||"$j >> $3
            done
        done
    fi
fi

touch $3
