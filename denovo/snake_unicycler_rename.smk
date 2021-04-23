configfile: "config_unicycler.yaml"

print("Starting Unicycler rename workflow")

rule all:
    input:
        expand("unicyclerOut/results/{sample}_assembly.fasta", sample = config["samples"])

#### gather the spades output into one folder

rule gather:
	input:
		gather="unicyclerOut/{sample}/{sample}_assembly.fasta"
	output:
		gather="unicyclerOut/results/{sample}_assembly.fasta"
	shell:
		"cp {input.gather} {output.gather}"

#### renaming the spades output
rule rename:
	input:
		rename="unicyclerOut/{sample}/assembly.fasta"
	output:
		rename="unicyclerOut/{sample}/{sample}_assembly.fasta"
	shell:
		"mv {input.rename} {output.rename}"
