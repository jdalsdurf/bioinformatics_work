#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in 01_assembly_results/ folder which is output of SPADES snake workflow
for entry in os.scandir("01_assembly_results/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"01_assembly_results/"+i for i in file_list}}

with open("config_abricate_argannot.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_argannot.yaml"

print("Starting abricate workflow")

rule abricate_all:
    input:
        expand("abricateResults/{sample}_abricate_vfdb.csv", sample = config["samples"]),
        expand("abricateResults/{sample}_abricate_card.csv", sample = config["samples"]),
    shell:
        "cat {input} > abricate_all.csv"

rule run_all:
    input:
        lambda wildcards: config["samples"][wildcards.sample]

    params:
        vfdb="vfdb",
        card="card",
        csv="csv",

    output:
        vfdb="abricateResults/{sample}_abricate_vfdb.csv",
        card="abricateResults/{sample}_abricate_card.csv",

    shell:
        """
        abricate {input} --csv --db {params.vfdb} > {output.vfdb}
        abricate {input} --csv --db {params.card} > {output.card}
        """
