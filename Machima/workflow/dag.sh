# DAG graph
snakemake -s workflow/download.smk --rulegraph | dot -Tpng > plot/download.png
snakemake -s workflow/preprocess.smk --rulegraph | dot -Tpng > plot/preprocess.png
snakemake -s workflow/stratify.smk --rulegraph | dot -Tpng > plot/stratify.png
snakemake -s workflow/common_dimension.smk --rulegraph | dot -Tpng > plot/common_dimension.png
snakemake -s workflow/dimreduct.smk --rulegraph | dot -Tpng > plot/dimreduct.png
snakemake -s workflow/deconvolution.smk --rulegraph | dot -Tpng > plot/deconvolution.png
snakemake -s workflow/plot.smk --rulegraph | dot -Tpng > plot/plot.png
