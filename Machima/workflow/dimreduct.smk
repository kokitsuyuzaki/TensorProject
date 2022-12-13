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
CHIPS = ['scChIPseq', 'pseudoBulkChIPseq', 'bulkChIPseq']
CHIPS2 = ['pseudoBulkChIPseq', 'bulkChIPseq']
DIM_REDUCTS = ['pca', 'nmf']

rule all:
    input:
        expand('output/{dim}/scRNAseq/{sc_sample}/output.RData',
            sc_sample=SCRNA_SAMPLES,
            dim=DIM_REDUCTS),
        expand('output/{dim}/{chip}/{hm}/{bin}/output.RData',
            chip=CHIPS,
            hm=HISTONE_MODIFICATIONS,
            bin=BINS,
            dim=DIM_REDUCTS),
        expand('output/nmf/scRNAseq/{sc_sample}/W_RNA.csv',
            sc_sample=SCRNA_SAMPLES),
        expand('output/nmf/scRNAseq/{sc_sample}/H_RNA.csv',
            sc_sample=SCRNA_SAMPLES),
        expand('output/nmf/{chip2}/{hm}/{bin}/W_Epi.csv',
            chip2=CHIPS2, hm=HISTONE_MODIFICATIONS, bin=BINS),
        expand('output/nmf/{chip2}/{hm}/{bin}/H_Epi.csv',
            chip2=CHIPS2, hm=HISTONE_MODIFICATIONS, bin=BINS),

rule dimreduct_scrna:
    input:
        'data/scRNAseq/{sc_sample}/X_RNA.csv',
        'data/scRNAseq/{sc_sample}/Label.csv'
    output:
        'output/{dim}/scRNAseq/{sc_sample}/output.RData'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/dimreduct_scrna_{sc_sample}_{dim}.txt'
    log:
        'logs/dimreduct_scrna_{sc_sample}_{dim}.log'
    shell:
        'src/{wildcards.dim}.sh {input} {output} >& {log}'

rule dimreduct_chip:
    input:
        'data/{chip}/{hm}/{bin}/X_Epi.csv',
        'data/{chip}/{hm}/{bin}/Label.csv'
    output:
        'output/{dim}/{chip}/{hm}/{bin}/output.RData'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/dimreduct_chip_{chip}_{hm}_{bin}_{dim}.txt'
    log:
        'logs/dimreduct_chip_{chip}_{hm}_{bin}_{dim}.log'
    shell:
        'src/{wildcards.dim}.sh {input} {output} >& {log}'

rule rdata_to_csv_scrna:
    input:
        'output/nmf/scRNAseq/{sc_sample}/output.RData'
    output:
        'output/nmf/scRNAseq/{sc_sample}/W_RNA.csv',
        'output/nmf/scRNAseq/{sc_sample}/H_RNA.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/rdata_to_csv_scrna_{sc_sample}.txt'
    log:
        'logs/rdata_to_csv_scrna_{sc_sample}.log'
    shell:
        'src/rdata_to_csv.sh {input} {output} >& {log}'

rule rdata_to_csv_chip:
    input:
        'output/nmf/{chip2}/{hm}/{bin}/output.RData'
    output:
        'output/nmf/{chip2}/{hm}/{bin}/W_Epi.csv',
        'output/nmf/{chip2}/{hm}/{bin}/H_Epi.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/rdata_to_csv_chip_{chip2}_{hm}_{bin}.txt'
    log:
        'logs/rdata_to_csv_chip_{chip2}_{hm}_{bin}.log'
    shell:
        'src/rdata_to_csv.sh {input} {output} >& {log}'