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

zcat $1

GCF_000005825.2_ASM582v2 = $1

zcat data/GCF_000005825.2_ASM582v2/*.fna.gz | grep plasmid




- plasmidはplasmidと書かれている
- 除外ルール: Candidatus|partial|chromosome.*(II|[2-9])
  で残ったものがchromosome
