# DAG graph
snakemake -s workflow/preprocess.smk --rulegraph | dot -Tpng > plot/preprocess.png
snakemake -s workflow/qc.smk --rulegraph | dot -Tpng > plot/qc.png
snakemake -s workflow/analysis.smk --rulegraph | dot -Tpng > plot/analysis.png
snakemake -s workflow/plot.smk --rulegraph | dot -Tpng > plot/plot.png

