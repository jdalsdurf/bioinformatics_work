configfile: "config_canu.yaml"

print("Starting canu gather workflow")

rule all:
    input:
        expand("CANU/results/{sample}_canu.contigs.fasta", sample = config["samples"])

#### gather the canu output into one folder

rule gather:
	input:
		gather="CANU/{sample}_canu/{sample}_canu.contigs.fasta"
	output:
		gather="CANU/results/{sample}_canu.contigs.fasta"
	shell:
		"cp {input.gather} {output.gather}"
