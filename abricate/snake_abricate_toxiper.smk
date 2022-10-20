#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in cperf_in/ folder which is output of SPADES snake workflow
for entry in os.scandir("cperf_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"cperf_in/"+i for i in file_list}}

with open("config_abricate_argannot.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_argannot.yaml"

print("Starting abricate workflow")

rule abricate_all:
    input:
        expand("abricateResults/{sample}_abricate_toxiper.csv", sample = config["samples"]),
    shell:
        "cat {input} > abricate_all.csv"

rule run_all:
    input:
        lambda wildcards: config["samples"][wildcards.sample]

    params:
        TOXIper="TOXIper",
        csv="csv",

    output:
        megares="abricateResults/{sample}_abricate_toxiper.csv",

    shell:
        """
        TOXIper.sh {input} > {output}
        """
