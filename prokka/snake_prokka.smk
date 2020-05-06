#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in results/ folder which is output of SPADES snake workflow
for entry in os.scandir("results/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"results/"+i for i in file_list}}

with open("config_prokka.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_prokka.yaml"

print("Starting Prokka workflow")

rule all:
    input:
        expand("prokka/results/{sample}_prokkaOut.gff", sample = config["samples"])

##### Prokka vfdb
rule prokka:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        "prokka/{sample}_prokkaOut/{sample}_prokkaOut.gff"
    params:
        name = "{sample}_prokkaOut",
        dir = "prokka/{sample}_prokkaOut"
    shell:
        "prokka --outdir {params.dir} --prefix {params.name} --centre X {input} --force"

rule gather:
	input:
		gather="prokka/{sample}_prokkaOut/{sample}_prokkaOut.gff"
	output:
		gather="prokka/results/{sample}_prokkaOut.gff"
	shell:
		"cp {input.gather} {output.gather}"
