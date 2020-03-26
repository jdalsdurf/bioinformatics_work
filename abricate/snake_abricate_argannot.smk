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

with open("config_abricate_argannot.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_argannot.yaml"

print("Starting abricate workflow")

rule all:
    input:
        expand("abricate_argannot/{sample}_abricate_argannot.csv", sample = config["samples"])

##### Abricate argannot
rule argannot:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    params:
        db_argannot = "argannot",
        type = "csv"
    output:
        argannot = "abricate_argannot/{sample}_abricate_argannot.csv",
    log:
        "logs/{sample}_argannot.log"

    shell:
        "abricate {input} --{params.type} --db {params.db_argannot} > {output.argannot}"
