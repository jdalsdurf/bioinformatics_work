#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in prokka_in/ folder which is output of SPADES snake workflow
for entry in os.scandir("prokka_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"prokka_in/"+i for i in file_list}}

with open("config_prokka.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_prokka.yaml"

print("Starting Prokka workflow")

rule all:
    input:
        expand("prokka/prokkaResults/{sample}.gff", sample = config["samples"])

##### Prokka vfdb
rule prokka:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        "prokka/{sample}_prokkaOut/{sample}_prokkaOut.gff"
    conda:
        "/home/jake/github/bioinformatics_work/env/prokka_env.yaml"
    params:
        name = "{sample}_prokkaOut",
        dir = "prokka/{sample}_prokkaOut"
    shell:
        "prokka --outdir {params.dir} --genus Moraxella --prefix {params.name} --centre X {input} --force"

rule gather:
	input:
		gather="prokka/{sample}_prokkaOut/{sample}_prokkaOut.gff"
	output:
		gather="prokka/prokkaResults/{sample}.gff"
	shell:
		"cp {input.gather} {output.gather}"

### genus Mycoplasma
