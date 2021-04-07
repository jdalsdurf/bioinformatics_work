#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in clean_fasta/ folder which is output of SPADES snake workflow
for entry in os.scandir("clean_fasta/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"clean_fasta/"+i for i in file_list}}

with open("config_abricate_asuis.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_asuis.yaml"

print("Starting abricate workflow")

rule all:
    input:
        expand("abricate_asuis/{sample}_abricate_asuis.csv", sample = config["samples"])
    shell:
        "cat {input} > asuis_all.csv"

##### Abricate asuis
rule asuis:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    params:
        db_asuis = "asuis",
        type = "csv"
    output:
        asuis = "abricate_asuis/{sample}_abricate_asuis.csv",
    log:
        "logs/{sample}_asuis.log"
    shell:
        "abricate {input} --{params.type} --db {params.db_asuis} > {output.asuis}"
