#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("mafft_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"mafft_in/"+i for i in file_list}}

with open("config_mafft.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_mafft.yaml"

print("Starting Mafft alignment workflow")

rule all:
    input:
        expand("mafftOut/{sample}_spades", sample = config["samples"])

#### running spades
rule spades:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        directory("mafftOut/{sample}")
    conda:
        "mafft_env.yaml"
    shell:
        "mafft {input} {output}"
