#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("trimmed/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"trimmed/"+i for i in file_list}}

with open("config.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config.yaml"

print("Starting SPADES analysis workflow")

rule all:
    input:
        expand("spades/results/{sample}_contigs.fasta", id = IDS), sample = config["samples"])

rule spades:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        directory("spadesOut/{sample}_spadesOut")
    shell:
        "sudo spades.py --sc --iontorrent --careful -k 21,33,55,77,99,127 -s {input} -o {output}"

#### renaming the spades output

rule rename:
	input:
		"spadesOut/{sample}_spadesOut/contigs.fasta"
	output:
		"spadesOut/{sample}_spades/{sample}_contigs.fasta"
	shell:
		"mv {input} {output}"

#### gather the spades output into one folde

rule all:
    input:
        expand("spades/results/{sample}_contigs.fasta", id = IDS)

rule gather:
	input:
		"spadesOut/{sample}_spadesOut/{sample}_contigs.fasta"
	output:
		"spadesOut/results/{sample}_contigs.fasta"
	shell:
		"cp {input} {output}"
