#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in results/ folder which is output of SPADES snake workflow
for entry in os.scandir("spadesOut/results/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"spadesOut/results/"+i for i in file_list}}

with open("config_abricate_ibv.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_ibv.yaml"

print("Starting abricate workflow")

rule all:
    input:
        expand("abricate_ibv/{sample}_abricate_ibv.csv", sample = config["samples"])
    shell:
        "cat {input} > ibv_all.csv"

##### Abricate ibv
rule ibv:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    params:
        db_ibv = "ibv",
        type = "csv"
    output:
        ibv = "abricate_ibv/{sample}_abricate_ibv.csv",
    log:
        "logs/{sample}_ibv.log"

    shell:
        "abricate {input} --{params.type} --db {params.db_ibv} > {output.ibv}"
