#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in fasta_input/ folder which is output of SPADES snake workflow
for entry in os.scandir("fasta_input/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"fasta_input/"+i for i in file_list}}

with open("config_abricate_megares.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_megares.yaml"

print("Starting abricate workflow")

rule all:
    input:
        expand("abricate_megares/{sample}_abricate_megares.csv", sample = config["samples"])
    shell:
        "cat {input} > megares_all.csv"

##### Abricate megares
rule megares:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    params:
        db_megares = "megares",
        type = "csv"
    output:
        megares = "abricate_megares/{sample}_abricate_megares.csv",
    log:
        "logs/{sample}_megares.log"

    shell:
        "abricate {input} --{params.type} --db {params.db_megares} > {output.megares}"
