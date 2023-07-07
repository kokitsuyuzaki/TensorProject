# TensorProjects/Plasmids

# Requirements
- Bash: GNU bash, version 4.2.46(1)-release (x86_64-redhat-linux-gnu)
- Snakemake: 6.0.5
- Singularity: 3.5.3

# How to reproduce this workflow

In local machine:

```
snakemake -s workflow/identifier.smk -j 4 --use-singularity
snakemake -s workflow/download.smk -j 4 --use-singularity
snakemake -s workflow/divide_plasmid_host.smk -j 4 --use-singularity
snakemake -s workflow/stats.smk -j 4 --use-singularity
snakemake -s workflow/rho.smk -j 4 --use-singularity
snakemake -s workflow/distance.smk -j 4 --use-singularity
snakemake -s workflow/roc.smk -j 4 --use-singularity
snakemake -s workflow/plot.smk -j 4 --use-singularity
```

In parallel environment (GridEngine):

```
snakemake -s workflow/identifier.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/download.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/divide_plasmid_host.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/stats.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/rho.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/distance.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
snakemake -s workflow/roc.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q large.q" --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster "qsub -l nc=4 -p -50 -r yes -q node.q" --latency-wait 600 --use-singularity
```

In parallel environment (Slurm):

```
snakemake -s workflow/identifier.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/download.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/divide_plasmid_host.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/stats.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/rho.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/distance.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/roc.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
snakemake -s workflow/plot.smk -j 32 --cluster sbatch --latency-wait 600 --use-singularity
```

# License
Copyright (c) 2021 Koki Tsuyuzaki [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).

# Authors
- Koki Tsuyuzaki