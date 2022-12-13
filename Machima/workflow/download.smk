import pandas as pd
from snakemake.utils import min_version

#
# Setting
#
min_version("6.0.5")
container: 'docker://koki/tensor-projects-machima:20220827'

BUIKCHIP_SAMPLES = ['ENCFF165VDC', 'ENCFF259JBE', 'ENCFF291LVP',
    'ENCFF298YTQ', 'ENCFF556EBC', 'ENCFF619ZKD', 'ENCFF636JEP',
    'ENCFF687HCJ']
HISTONE_MODIFICATIONS = ['H3K27me3', 'H3K4me3']
BINS = ['5000', '50000']
CHROMOSOMES = ["chr"+str(x) for x in list(range(1, 23))]

rule all:
    input:
        expand('data/bulkChIPseq/{bc_sample}.bed.sorted.{bin}.bin',
            bc_sample=BUIKCHIP_SAMPLES, bin=BINS),
        expand('data/scChIPseq/Jurkat_Ramos/Jurkat_Ramos_{hm}_{bin}/barcodes.tsv',
            hm=HISTONE_MODIFICATIONS, bin=BINS),
        expand('data/scChIPseq/Jurkat_Ramos/Jurkat_Ramos_{hm}_{bin}/features.tsv',
            hm=HISTONE_MODIFICATIONS, bin=BINS),
        expand('data/scChIPseq/Jurkat_Ramos/Jurkat_Ramos_{hm}_{bin}/matrix.mtx',
            hm=HISTONE_MODIFICATIONS, bin=BINS),
        expand('data/data/binning/{chromosome}.hg38.{bin}.bin',
            chromosome=CHROMOSOMES, bin=BINS),
        'data/data/refflat/refFlat.txt',
        expand('data/data/slidebase/out/{bin}.map_enhancer.{chromosome}.bed',
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/data/tss_distance/{bin}/{chromosome}/out.bed',
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/data/ucsc_tss/genes_tss/{chromosome}.genes.tss.bed',
            chromosome=CHROMOSOMES)

rule download_bulkchip:
    output:
        'data/bulkChIPseq/{bc_sample}.bed.sorted.{bin}.bin'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/download_bulkchip_{bc_sample}_{bin}.txt'
    log:
        'logs/download_bulkchip_{bc_sample}_{bin}.log'
    shell:
        'src/download_bulkchip.sh {wildcards.bc_sample} {wildcards.bin} >& {log}'

rule download_scchip:
    output:
        'data/scChIPseq/Jurkat_Ramos/Jurkat_Ramos_{hm}_{bin}/barcodes.tsv',
        'data/scChIPseq/Jurkat_Ramos/Jurkat_Ramos_{hm}_{bin}/features.tsv',
        'data/scChIPseq/Jurkat_Ramos/Jurkat_Ramos_{hm}_{bin}/matrix.mtx'
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/download_scchip_{hm}_{bin}.txt'
    log:
        'logs/download_scchip_{hm}_{bin}.log'
    shell:
        'src/download_scchip.sh {wildcards.hm} {wildcards.bin} >& {log}'

rule download_t:
    output:
        expand('data/data/binning/{chromosome}.hg38.{bin}.bin',
            chromosome=CHROMOSOMES, bin=BINS),
        'data/data/refflat/refFlat.txt',
        expand('data/data/slidebase/out/{bin}.map_enhancer.{chromosome}.bed',
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/data/tss_distance/{bin}/{chromosome}/out.bed',
            bin=BINS, chromosome=CHROMOSOMES),
        expand('data/data/ucsc_tss/genes_tss/{chromosome}.genes.tss.bed',
            chromosome=CHROMOSOMES)
    resources:
        mem_gb=100
    benchmark:
        'benchmarks/download_t.txt'
    log:
        'logs/download_t.log'
    shell:
        'src/download_t.sh >& {log}'
