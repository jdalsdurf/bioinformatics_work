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

with open("config_abricate_resfinder.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_resfinder.yaml"

print("Starting abricate workflow")

rule all:
    input:
        expand("abricate_resfinder/{sample}_abricate_resfinder.csv", sample = config["samples"])

##### Abricate resfinder
rule resfinder:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    params:
        db_resfinder = "leaveblank",
        type = "csv"
    output:
        res = "abricate_resfinder/{sample}_abricate_resfinder.csv",
    log:
        "logs/{sample}_resfinder.log"
    shell:
        "abricate {input} --{params.type} > {output.res}"
