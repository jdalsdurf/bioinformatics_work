#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in mlst_in/ folder which is output of SPADES snake workflow
for entry in os.scandir("mlst_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"mlst_in/"+i for i in file_list}}

with open("config_seqsero2.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_seqsero2.yaml"

print("Starting seqsero2 workflow")

rule all:
    input:
        expand("seqsero2/seqsero2Results/{sample}.tsv", sample = config["samples"])

##### Prokka vfdb
rule prokka:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        "seqsero2/{sample}_seqsero2Out/SeqSero_result.tsv"
    params:
        name = "{sample}",
        dir = "prokka/{sample}_prokkaOut"
    shell:
        "SeqSero2_package.py -m k -t 4 -i {input} -d {output} -n {params.name}"

rule gather:
	input:
		gather="seqsero2/{sample}_seqsero2Out/SeqSero_result.tsv"
	output:
		gather="seqsero2/seqsero2Results/{sample}.tsv"
	shell:
		"cp {input.gather} {output.gather}"

### genus Mycoplasma
