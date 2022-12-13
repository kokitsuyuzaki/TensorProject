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
    'Human_PBMC_4', 'Human_PBMC_5', 'Human_PBMC_6']
TB_SAMPLES = ['Human_TB_2', 'Human_TB_6']
CHIP_FILES = ['X_Epi.csv', 'RegionNames.csv', 'Label.csv']
RNA_FILES = ['X_RNA.csv', 'GeneNames.csv', 'Label.csv']
CHIPS = ['scChIPseq', 'pseudoBulkChIPseq', 'bulkChIPseq']
CHROMOSOMES = ["chr"+str(x) for x in list(range(1, 23))]

rule all:
    input:
        expand('data/bulkChIPseq/{hm}/{bin}/{cfile}',
            hm=HISTONE_MODIFICATIONS, bin=BINS, cfile=CHIP_FILES),
        expand('data/scChIPseq/{hm}/{bin}/{cfile}',
            hm=HISTONE_MODIFICATIONS, bin=BINS, cfile=CHIP_FILES),
        expand('data/pseudoBulkChIPseq/{hm}/{bin}/{cfile}',
            hm=HISTONE_MODIFICATIONS, bin=BINS, cfile=CHIP_FILES),
        expand('data/scRNAseq/{tb_sample}/{rfile}',
            tb_sample=TB_SAMPLES, rfile=RNA_FILES),
        expand('data/DistanceT/{bin}/{chromosome}/T.tsv',
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/DistanceT/{bin}/{chromosome}/RegionNames.tsv',
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/DistanceT/{bin}/{chromosome}/GeneNames.tsv',
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/EnhancerT/{bin}/{chromosome}/T.tsv',
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/EnhancerT/{bin}/{chromosome}/RegionNames.tsv',
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/EnhancerT/{bin}/{chromosome}/GeneNames.tsv',
            bin=BINS, chromosome=CHROMOSOMES),

rule preprocess_bulkchip:
    output:
        'data/bulkChIPseq/{hm}/{bin}/X_Epi.csv',
        'data/bulkChIPseq/{hm}/{bin}/RegionNames.csv',
        'data/bulkChIPseq/{hm}/{bin}/Label.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/preprocess_bulkchip_{hm}_{bin}.txt'
    log:
        'logs/preprocess_bulkchip_{hm}_{bin}.log'
    shell:
        'src/preprocess_bulkchip.sh {wildcards.hm} {wildcards.bin} {output} >& {log}'

rule preprocess_scchip:
    output:
        'data/scChIPseq/{hm}/{bin}/X_Epi.csv',
        'data/scChIPseq/{hm}/{bin}/RegionNames.csv',
        'data/scChIPseq/{hm}/{bin}/Label.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/preprocess_scchip_{hm}_{bin}.txt'
    log:
        'logs/preprocess_scchip_{hm}_{bin}.log'
    shell:
        'src/preprocess_scchip.sh {wildcards.hm} {wildcards.bin} {output} >& {log}'

rule preprocess_pseudo_bulkchip:
    input:
        'data/scChIPseq/{hm}/{bin}/X_Epi.csv',
        'data/scChIPseq/{hm}/{bin}/RegionNames.csv',
        'data/scChIPseq/{hm}/{bin}/Label.csv'
    output:
        'data/pseudoBulkChIPseq/{hm}/{bin}/X_Epi.csv',
        'data/pseudoBulkChIPseq/{hm}/{bin}/RegionNames.csv',
        'data/pseudoBulkChIPseq/{hm}/{bin}/Label.csv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/preprocess_pseudo_bulkchip_{hm}_{bin}.txt'
    log:
        'logs/preprocess_pseudo_bulkchip_{hm}_{bin}.log'
    shell:
        'src/preprocess_pseudo_bulkchip.sh {input} {output} >& {log}'

rule preprocess_distance_t:
    input:
        'data/data/tss_distance/{bin}/{chromosome}/out.bed',
    output:
        'data/data/tss_distance/{bin}/{chromosome}/out2.bed'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/preprocess_distance_t_{bin}_{chromosome}.txt'
    log:
        'logs/preprocess_distance_t_{bin}_{chromosome}.log'
    shell:
        'src/preprocess_distance_t.sh {input} {output} >& {log}'

rule preprocess_distance_t_2:
    input:
        'data/data/tss_distance/{bin}/{chromosome}/out2.bed',
    output:
        'data/DistanceT/{bin}/{chromosome}/T.tsv',
        'data/DistanceT/{bin}/{chromosome}/RegionNames.tsv',
        'data/DistanceT/{bin}/{chromosome}/GeneNames.tsv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/preprocess_distance_t_2_{bin}_{chromosome}.txt'
    log:
        'logs/preprocess_distance_t_2_{bin}_{chromosome}.log'
    shell:
        'src/preprocess_distance_t_2.sh {input} {output} >& {log}'

rule preprocess_enhancer_t:
    input:
        'data/data/slidebase/out/{bin}.map_enhancer.{chromosome}.bed'
    output:
        'data/EnhancerT/{bin}/{chromosome}/T.tsv',
        'data/EnhancerT/{bin}/{chromosome}/RegionNames.tsv',
        'data/EnhancerT/{bin}/{chromosome}/GeneNames.tsv'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/preprocess_enhancer_t_{bin}_{chromosome}.txt'
    log:
        'logs/preprocess_enhancer_t_{bin}_{chromosome}.log'
    shell:
        'src/preprocess_enhancer_t.sh {input} {output} >& {log}'


rule preprocess_scrna:
    output:
        'data/scRNAseq/{sr_sample}/X_RNA.csv',
        'data/scRNAseq/{sr_sample}/GeneNames.csv',
        'data/scRNAseq/{sr_sample}/Label.csv'
    wildcard_constraints:
        sr_sample='|'.join([re.escape(x) for x in SCRNA_SAMPLES])
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/preprocess_scrna_{sr_sample}.txt'
    log:
        'logs/preprocess_scrna_{sr_sample}.log'
    shell:
        'src/preprocess_{wildcards.sr_sample}.sh {output} >& {log}'

rule preprocess_tb_scrna:
    input:
        expand('data/scRNAseq/{sr_sample}/{rfile}',
            sr_sample=SCRNA_SAMPLES, rfile=RNA_FILES)
    output:
        'data/scRNAseq/{tb_sample}/X_RNA.csv',
        'data/scRNAseq/{tb_sample}/GeneNames.csv',
        'data/scRNAseq/{tb_sample}/Label.csv'
    wildcard_constraints:
        tb_sample='|'.join([re.escape(x) for x in TB_SAMPLES])
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/preprocess_tb_scrna_{tb_sample}.txt'
    log:
        'logs/preprocess_tb_scrna_{tb_sample}.log'
    shell:
        'src/preprocess_{wildcards.tb_sample}.sh {output} >& {log}'
