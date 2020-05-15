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

with open("config_canu.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_canu.yaml"

print("Starting CANU analysis workflow")

rule all:
    input:
        expand("CANU/{sample}_canu", sample = config["samples"])

#### running spades
rule canu:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    params:
        size="2k",
        name="{sample}_canu"
    output:
        directory("CANU/{sample}_canu")
    shell:
        "canu -p {params.name} -d {output} -genomeSize={params.size} -nanopore {input}"
