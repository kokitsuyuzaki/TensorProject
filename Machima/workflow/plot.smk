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
CHIPS = ['scChIPseq', 'pseudoBulkChIPseq', 'bulkChIPseq']
CHIPS2 = ['pseudoBulkChIPseq', 'bulkChIPseq']
OUTFILES = ['X_RNA.csv', 'GeneNames.csv', 'Label.csv']
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
DIM_REDUCTS = ['pca', 'nmf']

rule all:
    input:
        expand('plot/scRNAseq/{sc_sample}/{dim}.png',
            sc_sample=SCRNA_SAMPLES,
            dim=DIM_REDUCTS),
        expand('plot/{chip}/{hm}/{bin}/{dim}.png',
            chip=CHIPS, hm=HISTONE_MODIFICATIONS,
            bin=BINS, dim=DIM_REDUCTS),
        expand('plot/{machima}/{sc_sample}/{chip2}/{hm}/{bin}_H_RNA.png',
            machima=MACHIMA_MODES, sc_sample=SCRNA_SAMPLES,
            chip2=CHIPS2, hm=HISTONE_MODIFICATIONS,
            bin=BINS),
        expand('plot/{machima}/{sc_sample}/{chip2}/{hm}/{bin}_H_Epi.png',
            machima=MACHIMA_MODES, sc_sample=SCRNA_SAMPLES,
            chip2=CHIPS2, hm=HISTONE_MODIFICATIONS,
            bin=BINS),
        expand('plot/ratio/{machima}/{sc_sample}_{hm}_{bin}.png',
        machima=MACHIMA_MODES, sc_sample=SCRNA_SAMPLES,
        hm=HISTONE_MODIFICATIONS, bin=BINS)

rule plot_dimreduct_scrna:
    input:
        'output/{dim}/scRNAseq/{sc_sample}/output.RData',
        'data/scRNAseq/{sc_sample}/Label.csv'
    output:
        'plot/scRNAseq/{sc_sample}/{dim}.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_dimreduct_scrna_{sc_sample}_{dim}.txt'
    log:
        'logs/plot_dimreduct_scrna_{sc_sample}_{dim}.log'
    shell:
        'src/plot_dimreduct.sh {input} {output} >& {log}'

rule plot_dimreduct_chip:
    input:
        'output/{dim}/{chip}/{hm}/{bin}/output.RData',
        'data/{chip}/{hm}/{bin}/Label.csv'
    output:
        'plot/{chip}/{hm}/{bin}/{dim}.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_dimreduct_chip_{chip}_{hm}_{bin}_{dim}.txt'
    log:
        'logs/plot_dimreduct_chip_{chip}_{hm}_{bin}_{dim}.log'
    shell:
        'src/plot_dimreduct.sh {input} {output} >& {log}'

rule plot_machima:
    input:
        'output/{machima}/{sc_sample}/{chip2}/{hm}/{bin}/output.RData',
        'data/scRNAseq/{sc_sample}/Label.csv',
        'data/{chip2}/{hm}/{bin}/Label.csv'
    output:
        'plot/{machima}/{sc_sample}/{chip2}/{hm}/{bin}_H_RNA.png',
        'plot/{machima}/{sc_sample}/{chip2}/{hm}/{bin}_H_Epi.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_machima_{machima}_{sc_sample}_{chip2}_{hm}_{bin}.txt'
    log:
        'logs/plot_machima_{machima}_{sc_sample}_{chip2}_{hm}_{bin}.log'
    shell:
        'src/plot_machima.sh {input} {output} >& {log}'

rule plot_ratio:
    input:
        'output/{machima}/{sc_sample}/pseudoBulkChIPseq/{hm}/{bin}/output.RData',
        'data/scRNAseq/{sc_sample}/Label.csv',
        'data/pseudoBulkChIPseq/{hm}/{bin}/Label.csv'
    output:
        'plot/ratio/{machima}/{sc_sample}_{hm}_{bin}.png'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/plot_ratio_{machima}_{sc_sample}_{hm}_{bin}.txt'
    log:
        'logs/plot_ratio_{machima}_{sc_sample}_{hm}_{bin}.log'
    shell:
        'src/plot_ratio.sh {input} {output} >& {log}'
