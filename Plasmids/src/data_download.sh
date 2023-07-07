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

DIR=`echo $1 | sed 's|/.*||g'`
FILE=`echo $1 | sed 's|.*/||g'`
URL=`grep $FILE data/ftpfilepaths.txt`

cd data/$DIR

sleep $(($RANDOM % 120))
axel -n 6 $URL -o $FILE

if [ -e $FILE ]; then
    touch $FILE
fi
