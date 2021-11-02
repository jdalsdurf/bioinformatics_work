configfile: "config_IRMA_SIV_wholeGenome.yaml"

# print("Starting IRMA IBV analysis workflow")

rule all:
    input:
        expand("irmaOut_SIV/IRMA_results/{sample}_all.fasta", sample = config["samples"])

rule irma_SIV_rename:
    input:
        "irmaOut_SIV/{sample}_irmaOut/*.fasta"
    output:
        "irmaOut_SIV/IRMA_results/{sample}_all.fasta"
    shell:
        "cat {input.fasta} > {output}"
