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

print("Starting IRMA IBV analysis workflow")

rule all:
    input:
        expand("irmaOut/{sample}_irmaOut", sample = config["samples"])

rule irma_IBV:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        directory("irmaOut/{sample}_irmaOut")
    shell:
        "sudo ~/flu-amd/IRMA prrs {input} {output}"
