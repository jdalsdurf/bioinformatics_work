configfile: "config_flye.yaml"

rule all:
    input:
        expand("medakaOut/results/{sample}_medaka_consensus.fasta", sample = config["samples"])

########### medaka polishing
rule gather:
	input:
		gather="medakaOut/{sample}_medaka/{sample}_medaka_consensus.fasta"
	output:
		gather="medakaOut/results/{sample}_medaka_consensus.fasta"
	shell:
		"cp {input.gather} {output.gather}"

#### renaming the spades output
rule rename:
	input:
		rename="medakaOut/{sample}_medaka/consensus.fasta"
	output:
		rename="medakaOut/{sample}_medaka/{sample}_medaka_consensus.fasta"
	shell:
		"mv {input.rename} {output.rename}"


