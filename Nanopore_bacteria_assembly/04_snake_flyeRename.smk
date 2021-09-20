configfile: "config_flye.yaml"

print("Starting Unicycler analysis workflow")

rule all:
    input:
        expand("flyeOut/results/{sample}_assembly.fasta", sample = config["samples"]),
        expand("flyeOut/results/{sample}_assembly_graph.gfa", sample = config["samples"]),

rule gather:
	input:
		gather="flyeOut/{sample}_flye/{sample}_assembly.fasta"
	output:
		gather="flyeOut/results/{sample}_assembly.fasta"
	shell:
		"cp {input.gather} {output.gather}"

#### renaming the spades output
rule rename:
	input:
		rename="flyeOut/{sample}_flye/assembly.fasta"
	output:
		rename="flyeOut/{sample}_flye/{sample}_assembly.fasta"
	shell:
		"mv {input.rename} {output.rename}"

rule gather_gfa:
	input:
		gather="flyeOut/{sample}_flye/{sample}_assembly_graph.gfa"
	output:
		gather="flyeOut/results/{sample}_assembly_graph.gfa"
	shell:
		"cp {input.gather} {output.gather}"

#### renaming the spades output
rule rename_gfa:
	input:
		rename="flyeOut/{sample}_flye/assembly_graph.gfa"
	output:
		rename="flyeOut/{sample}_flye/{sample}_assembly_graph.gfa"
	shell:
		"mv {input.rename} {output.rename}"

