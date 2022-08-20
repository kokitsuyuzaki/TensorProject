# HTML
mkdir -p report
snakemake -s workflow/preprocess.smk --report report/preprocess.html
snakemake -s workflow/qc.smk --report report/qc.html
snakemake -s workflow/analysis.smk --report report/analysis.html
snakemake -s workflow/plot.smk --report report/plot.html
