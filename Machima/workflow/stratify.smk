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
CHIP_FILES = ['X_Epi.csv', 'RegionNames.csv', 'Label.csv']
RNA_FILES = ['X_RNA.csv', 'GeneNames.csv', 'Label.csv']
CHROMOSOMES = ["chr"+str(x) for x in list(range(1, 23))]
CHIPS2 = ['pseudoBulkChIPseq', 'bulkChIPseq']

rule all:
    input:
        expand('data/bulkChIPseq/{hm}/{bin}/{chromosome}/{cfile}',
            hm=HISTONE_MODIFICATIONS, bin=BINS,
            chromosome=CHROMOSOMES, cfile=CHIP_FILES),
        expand('data/scChIPseq/{hm}/{bin}/{chromosome}/{cfile}',
            hm=HISTONE_MODIFICATIONS, bin=BINS,
            chromosome=CHROMOSOMES, cfile=CHIP_FILES),
        expand('data/pseudoBulkChIPseq/{hm}/{bin}/{chromosome}/{cfile}',
            hm=HISTONE_MODIFICATIONS, bin=BINS,
            chromosome=CHROMOSOMES, cfile=CHIP_FILES),
        expand('data/scRNAseq/{sr_sample}/{chromosome}/{rfile}',
            sr_sample=SCRNA_SAMPLES,
            chromosome=CHROMOSOMES, rfile=RNA_FILES),
        expand('output/nmf/{chip2}/{hm}/{bin}/{chromosome}/W_Epi.csv',
            chip2=CHIPS2, hm=HISTONE_MODIFICATIONS,
            bin=BINS, chromosome=CHROMOSOMES),
        expand('output/nmf/{chip2}/{hm}/{bin}/{chromosome}/RegionNames.csv',
            chip2=CHIPS2, hm=HISTONE_MODIFICATIONS,
            bin=BINS, chromosome=CHROMOSOMES),
        expand('output/nmf/{chip2}/{hm}/{bin}/{chromosome}/Label.csv',
            chip2=CHIPS2, hm=HISTONE_MODIFICATIONS,
            bin=BINS, chromosome=CHROMOSOMES),
        expand('output/nmf/scRNAseq/{sc_sample}/{chromosome}/W_RNA.csv',
            sc_sample=SCRNA_SAMPLES, chromosome=CHROMOSOMES),
        expand('output/nmf/scRNAseq/{sc_sample}/{chromosome}/GeneNames.csv',
            sc_sample=SCRNA_SAMPLES, chromosome=CHROMOSOMES),
        expand('output/nmf/scRNAseq/{sc_sample}/{chromosome}/Label.csv',
            sc_sample=SCRNA_SAMPLES, chromosome=CHROMOSOMES),

rule stratify_bulkchip:
    input:
        'data/bulkChIPseq/{hm}/{bin}/X_Epi.csv',
        'data/bulkChIPseq/{hm}/{bin}/RegionNames.csv',
        'data/bulkChIPseq/{hm}/{bin}/Label.csv'
    output:
        'data/bulkChIPseq/{hm}/{bin}/{chromosome}/X_Epi.csv',
        'data/bulkChIPseq/{hm}/{bin}/{chromosome}/RegionNames.csv',
        'data/bulkChIPseq/{hm}/{bin}/{chromosome}/Label.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/stratify_bulkchip_{hm}_{bin}_{chromosome}.txt'
    log:
        'logs/stratify_bulkchip_{hm}_{bin}_{chromosome}.log'
    shell:
        'src/stratify_chip.sh {input} {wildcards.chromosome} {output} >& {log}'

rule stratify_scchip:
    input:
        'data/scChIPseq/{hm}/{bin}/X_Epi.csv',
        'data/scChIPseq/{hm}/{bin}/RegionNames.csv',
        'data/scChIPseq/{hm}/{bin}/Label.csv'
    output:
        'data/scChIPseq/{hm}/{bin}/{chromosome}/X_Epi.csv',
        'data/scChIPseq/{hm}/{bin}/{chromosome}/RegionNames.csv',
        'data/scChIPseq/{hm}/{bin}/{chromosome}/Label.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/stratify_scchip_{hm}_{bin}_{chromosome}.txt'
    log:
        'logs/stratify_scchip_{hm}_{bin}_{chromosome}.log'
    shell:
        'src/stratify_chip.sh {input} {wildcards.chromosome} {output} >& {log}'

rule stratify_pseudo_bulkchip:
    input:
        'data/pseudoBulkChIPseq/{hm}/{bin}/X_Epi.csv',
        'data/pseudoBulkChIPseq/{hm}/{bin}/RegionNames.csv',
        'data/pseudoBulkChIPseq/{hm}/{bin}/Label.csv'
    output:
        'data/pseudoBulkChIPseq/{hm}/{bin}/{chromosome}/X_Epi.csv',
        'data/pseudoBulkChIPseq/{hm}/{bin}/{chromosome}/RegionNames.csv',
        'data/pseudoBulkChIPseq/{hm}/{bin}/{chromosome}/Label.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/stratify_pseudo_bulkchip_{hm}_{bin}_{chromosome}.txt'
    log:
        'logs/stratify_pseudo_bulkchip_{hm}_{bin}_{chromosome}.log'
    shell:
        'src/stratify_chip.sh {input} {wildcards.chromosome} {output} >& {log}'

rule stratify_chip_w:
    input:
        'output/nmf/{chip2}/{hm}/{bin}/W_Epi.csv',
        'data/{chip2}/{hm}/{bin}/RegionNames.csv',
        'data/{chip2}/{hm}/{bin}/Label.csv'
    output:
        'output/nmf/{chip2}/{hm}/{bin}/{chromosome}/W_Epi.csv',
        'output/nmf/{chip2}/{hm}/{bin}/{chromosome}/RegionNames.csv',
        'output/nmf/{chip2}/{hm}/{bin}/{chromosome}/Label.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/stratify_chip_w_{chip2}_{hm}_{bin}_{chromosome}.txt'
    log:
        'logs/stratify_chip_w_{chip2}_{hm}_{bin}_{chromosome}.log'
    shell:
        'src/stratify_chip.sh {input} {wildcards.chromosome} {output} >& {log}'

rule stratify_rna:
    input:
        'data/scRNAseq/{sr_sample}/X_RNA.csv',
        'data/scRNAseq/{sr_sample}/GeneNames.csv',
        'data/scRNAseq/{sr_sample}/Label.csv'
    output:
        'data/scRNAseq/{sr_sample}/{chromosome}/X_RNA.csv',
        'data/scRNAseq/{sr_sample}/{chromosome}/GeneNames.csv',
        'data/scRNAseq/{sr_sample}/{chromosome}/Label.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/stratify_rna_{sr_sample}_{chromosome}.txt'
    log:
        'logs/stratify_rna_{sr_sample}_{chromosome}.log'
    shell:
        'src/stratify_rna.sh {input} {wildcards.chromosome} {output} >& {log}'

rule stratify_rna_w:
    input:
        'output/nmf/scRNAseq/{sc_sample}/W_RNA.csv',
        'data/scRNAseq/{sc_sample}/GeneNames.csv',
        'data/scRNAseq/{sc_sample}/Label.csv'
    output:
        'output/nmf/scRNAseq/{sc_sample}/{chromosome}/W_RNA.csv',
        'output/nmf/scRNAseq/{sc_sample}/{chromosome}/GeneNames.csv',
        'output/nmf/scRNAseq/{sc_sample}/{chromosome}/Label.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/stratify_rna_w_{sc_sample}_{chromosome}.txt'
    log:
        'logs/stratify_rna_w_{sc_sample}_{chromosome}.log'
    shell:
        'src/stratify_rna.sh {input} {wildcards.chromosome} {output} >& {log}'