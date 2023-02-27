configfile: "config_spades.yaml"

print("Starting SPADES analysis workflow")

rule all:
    input:
        expand("spadesOut/results/{sample}_contigs.fasta", sample = config["samples"])

#### gather the spades output into one folder

rule gather:
	input:
		gather="spadesOut/{sample}_spades/{sample}_contigs.fasta"
	output:
		gather="spadesOut/results/{sample}_contigs.fasta"
	shell:
		"cp {input.gather} {output.gather}"

#### renaming the spades output
rule rename:
	input:
		rename="spadesOut/{sample}_spades/contigs.fasta"
	output:
		rename="spadesOut/{sample}_spades/{sample}_contigs.fasta"
	shell:
		"mv {input.rename} {output.rename}"
