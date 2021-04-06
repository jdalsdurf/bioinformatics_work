configfile: "config_unicycler.yaml"

print("Starting Unicycler rename workflow")

rule all:
    input:
        expand("UnicyclerResult/results/{sample}_assembly.fasta", sample = config["samples"])

#### gather the spades output into one folder

rule gather:
	input:
		gather="UnicyclerResult/{sample}/{sample}_assembly.fasta"
	output:
		gather="UnicyclerResult/results/{sample}_assembly.fasta"
	shell:
		"cp {input.gather} {output.gather}"

#### renaming the spades output
rule rename:
	input:
		rename="UnicyclerResult/{sample}/assembly.fasta"
	output:
		rename="UnicyclerResult/{sample}/{sample}_assembly.fasta"
	shell:
		"mv {input.rename} {output.rename}"
