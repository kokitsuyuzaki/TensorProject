import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-projects-machima:20220716'

BINS = ['5000', '50000']
SCRNA_SAMPLES = [
    'Human_PBMC_1', 'Human_PBMC_2', 'Human_PBMC_3',
    'Human_PBMC_4', 'Human_PBMC_5', 'Human_PBMC_6',
    'Human_TB_2', 'Human_TB_6']
CHROMOSOMES = ['chr'+str(x) for x in list(range(1, 23))]
HISTONE_MODIFICATIONS = ['H3K27me3', 'H3K4me3']
CHIPS = ['pseudoBulkChIPseq', 'bulkChIPseq']
Ts = ['DistanceT', 'EnhancerT']

rule all:
    input:
        expand('data/common/scRNAseq/{sc_sample}/{bin}/{chromosome}/X_RNA.csv',
            sc_sample=SCRNA_SAMPLES, bin=BINS, chromosome=CHROMOSOMES),
        expand('data/common/{chip}/{hm}/{bin}/{chromosome}/X_Epi.csv',
            chip=CHIPS, hm=HISTONE_MODIFICATIONS,
            sc_sample=SCRNA_SAMPLES, bin=BINS, chromosome=CHROMOSOMES),
        expand('data/common/{t}/{hm}/{bin}/{chromosome}/T.tsv',
            t=Ts, hm=HISTONE_MODIFICATIONS, bin=BINS, chromosome=CHROMOSOMES),

def aggregate_sc_sample_genenames(chromosome):
    out = []
    for j in range(len(SCRNA_SAMPLES)):
            out.append('data/scRNAseq/' + SCRNA_SAMPLES[j] + '/' + '{chromosome}/GeneNames.csv')
    return(out)

rule common_column_dimension:
    input:
        aggregate_sc_sample_genenames,
        'data/DistanceT/{bin}/{chromosome}/GeneNames.tsv',
        'data/EnhancerT/{bin}/{chromosome}/GeneNames.tsv'
    output:
        'data/common/{bin}/{chromosome}/GeneNames.tsv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/common_column_dimension_{bin}_{chromosome}.txt'
    log:
        'logs/common_column_dimension_{bin}_{chromosome}.log'
    shell:
        'src/common_dimension.sh {input} {output} >& {log}'

rule common_row_dimension:
    input:
        'data/bulkChIPseq/{hm}/{bin}/{chromosome}/RegionNames.csv',
        'data/pseudoBulkChIPseq/{hm}/{bin}/{chromosome}/RegionNames.csv',
        'data/DistanceT/{bin}/{chromosome}/RegionNames.tsv',
        'data/EnhancerT/{bin}/{chromosome}/RegionNames.tsv'
    output:
        'data/common/{hm}/{bin}/{chromosome}/RegionNames.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/common_row_dimension_{hm}_{bin}_{chromosome}.txt'
    log:
        'logs/common_row_dimension_{hm}_{bin}_{chromosome}.log'
    shell:
        'src/common_dimension.sh {input} {output} >& {log}'

rule common_matrix_scrna:
    input:
        'data/scRNAseq/{sc_sample}/{chromosome}/X_RNA.csv',
        'data/scRNAseq/{sc_sample}/{chromosome}/GeneNames.csv',
        'data/common/{bin}/{chromosome}/GeneNames.tsv'
    output:
        'data/common/scRNAseq/{sc_sample}/{bin}/{chromosome}/X_RNA.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/common_matrix_scrna_{sc_sample}_{bin}_{chromosome}.txt'
    log:
        'logs/common_matrix_scrna_{sc_sample}_{bin}_{chromosome}.log'
    shell:
        'src/common_matrix.sh {input} {output} >& {log}'

rule common_matrix_chip:
    input:
        'data/{chip}/{hm}/{bin}/{chromosome}/X_Epi.csv',
        'data/{chip}/{hm}/{bin}/{chromosome}/RegionNames.csv',
        'data/common/{hm}/{bin}/{chromosome}/RegionNames.csv'
    output:
        'data/common/{chip}/{hm}/{bin}/{chromosome}/X_Epi.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/common_matrix_chip_{chip}_{hm}_{bin}_{chromosome}.txt'
    log:
        'logs/common_matrix_chip_{chip}_{hm}_{bin}_{chromosome}.log'
    shell:
        'src/common_matrix.sh {input} {output} >& {log}'

rule common_matrix_t:
    input:
        'data/{t}/{bin}/{chromosome}/T.tsv',
        'data/{t}/{bin}/{chromosome}/RegionNames.tsv',
        'data/common/{hm}/{bin}/{chromosome}/RegionNames.csv',
        'data/{t}/{bin}/{chromosome}/GeneNames.tsv',
        'data/common/{bin}/{chromosome}/GeneNames.tsv'
    output:
        'data/common/{t}/{hm}/{bin}/{chromosome}/T.tsv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/common_matrix_t_{t}_{hm}_{bin}_{chromosome}.txt'
    log:
        'logs/common_matrix_t_{t}_{hm}_{bin}_{chromosome}.log'
    shell:
        'src/common_matrix_t.sh {input} {output} >& {log}'
