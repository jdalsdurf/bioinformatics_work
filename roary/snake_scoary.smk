#### running scoary
rule scoary:
    input:
        trait="trait.csv",
        gene="gene_presence_absence.csv",
    output:
        directory("scoaryOut/")
    conda:
        "scoary_env.yaml"
    shell:
        "scoary -t {input.trait} -g {input.gene} -o {output} --threads 32 -p 1 -u"
