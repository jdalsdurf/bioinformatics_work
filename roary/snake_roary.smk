#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("gff_folder/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"gff_folder/"+i for i in file_list}}

with open("config_roary.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front

configfile: "config_roary.yaml"

print("Starting Roary analysis workflow")

rule all:
    input:
        expand("roaryOut/", sample = config["samples"])

rule spades:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        directory("roaryOut/")
    shell:
        "roary -f {output} -env {input}"
