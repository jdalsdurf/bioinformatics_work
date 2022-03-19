#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in filterlong_in folder
for entry in os.scandir("ncbi_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".fasta")[0]:"ncbi_in/"+i for i in file_list}}

with open("config_ncbi.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_ncbi.yaml"

rule all:
    input:
        expand("ncbiBlastOut/{sample}_blast.txt", sample = config["samples"])

rule blast:
	input:
		"ncbi_in/{sample}.fasta"
	params:
		"/media/Sequencing/bioinformatics/databases/blastdb/16S_ribosomal_RNA"
	output:
		"ncbiBlastOut/{sample}_blast.txt"
	conda:
		"/home/github/bioinformatics_work/env/blast_env.yaml"
	shell:
		"blastn -query {input} -db {params} -out {output}"
