import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-projects-machima:20220827'

HISTONE_MODIFICATIONS = ['H3K27me3', 'H3K4me3']
BINS = ['5000', '50000']
SCRNA_SAMPLES = [
    'Human_PBMC_1', 'Human_PBMC_2', 'Human_PBMC_3',
    'Human_PBMC_4', 'Human_PBMC_5', 'Human_PBMC_6',
    'Human_TB_2', 'Human_TB_6']
CHROMOSOMES = ['chr'+str(x) for x in list(range(1, 23))]
CHIPS = ['pseudoBulkChIPseq', 'bulkChIPseq']
MACHIMA_MODES = ['machima', 'machima_fixwh',
    'machima_gw', 'machima_gw_fixwh',
    'machima_distance_50', 'machima_distance_50_fixwh',
    'machima_distance_500', 'machima_distance_500_fixwh',
    'machima_distance_5000', 'machima_distance_5000_fixwh',
    'machima_distance_50000', 'machima_distance_50000_fixwh',
    'machima_distance_500000', 'machima_distance_500000_fixwh',
    'machima_decay_50_d0', 'machima_decay_50_d0_fixwh',
    'machima_decay_500_d0', 'machima_decay_500_d0_fixwh',
    'machima_decay_5000_d0', 'machima_decay_5000_d0_fixwh',
    'machima_decay_50000_d0', 'machima_decay_50000_d0_fixwh',
    'machima_decay_500000_d0', 'machima_decay_500000_d0_fixwh',
    'machima_enhancer', 'machima_enhancer_fixwh',
    'machima_gw_horizontal', 'machima_gw_fixwh_horizontal',
    'machima_distance_50_horizontal', 'machima_distance_50_fixwh_horizontal',
    'machima_distance_500_horizontal', 'machima_distance_500_fixwh_horizontal',
    'machima_distance_5000_horizontal', 'machima_distance_5000_fixwh_horizontal',
    'machima_distance_50000_horizontal', 'machima_distance_50000_fixwh_horizontal',
    'machima_distance_500000_horizontal', 'machima_distance_500000_fixwh_horizontal',
    'machima_decay_50_d0_horizontal', 'machima_decay_50_d0_fixwh_horizontal',
    'machima_decay_500_d0_horizontal', 'machima_decay_500_d0_fixwh_horizontal',
    'machima_decay_5000_d0_horizontal', 'machima_decay_5000_d0_fixwh_horizontal',
    'machima_decay_50000_d0_horizontal', 'machima_decay_50000_d0_fixwh_horizontal',
    'machima_decay_500000_d0_horizontal', 'machima_decay_500000_d0_fixwh_horizontal',
    'machima_enhancer_horizontal', 'machima_enhancer_fixwh_horizontal']

rule all:
    input:
        expand('output/{machima}/{sc_sample}/{chip}/{hm}/{bin}/output.RData',
        machima=MACHIMA_MODES,
        sc_sample=SCRNA_SAMPLES, chip=CHIPS,
        hm=HISTONE_MODIFICATIONS, bin=BINS)

rule gromov_wasserstein:
    input:
        'data/common/scRNAseq/{sc_sample}/{bin}/{chromosome}/X_RNA.csv',
        'data/common/{chip}/{hm}/{bin}/{chromosome}/X_Epi.csv'
    output:
        'output/gromov_wasserstein/{sc_sample}/{chip}/{hm}/{bin}/{chromosome}/T.csv',
        'output/gromov_wasserstein/{sc_sample}/{chip}/{hm}/{bin}/{chromosome}/X_GAM.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/gromov_wasserstein_{sc_sample}_{chip}_{hm}_{bin}_{chromosome}.txt'
    log:
        'logs/gromov_wasserstein_{sc_sample}_{chip}_{hm}_{bin}_{chromosome}.log'
    shell:
        'src/gromov_wasserstein.sh {input} {output} >& {log}'

rule machima:
    input:
        expand('data/common/scRNAseq/{sc_sample}/{bin}/{chromosome}/X_RNA.csv',
            sc_sample=SCRNA_SAMPLES, bin=BINS, chromosome=CHROMOSOMES),
        expand('data/common/{chip}/{hm}/{bin}/{chromosome}/X_Epi.csv',
            chip=CHIPS, hm=HISTONE_MODIFICATIONS,
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/common/DistanceT/{hm}/{bin}/{chromosome}/T.tsv',
            chip=CHIPS, hm=HISTONE_MODIFICATIONS,
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/common/EnhancerT/{hm}/{bin}/{chromosome}/T.tsv',
            chip=CHIPS, hm=HISTONE_MODIFICATIONS,
            bin=BINS, chromosome=CHROMOSOMES),
        expand('output/gromov_wasserstein/{sc_sample}/{chip}/{hm}/{bin}/{chromosome}/T.csv',
            sc_sample=SCRNA_SAMPLES,
            chip=CHIPS, hm=HISTONE_MODIFICATIONS,
            bin=BINS, chromosome=CHROMOSOMES)
    output:
        'output/{machima}/{sc_sample}/{chip}/{hm}/{bin}/output.RData'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/{machima}_{sc_sample}_{chip}_{hm}_{bin}.txt'
    log:
        'logs/{machima}_{sc_sample}_{chip}_{hm}_{bin}.log'
    shell:
        'src/{wildcards.machima}.sh {wildcards.sc_sample} {wildcards.chip} {wildcards.hm} {wildcards.bin} {output} >& {log}'