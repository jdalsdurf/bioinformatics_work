#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in ecoli_in/ folder which is output of SPADES snake workflow
for entry in os.scandir("ecoli_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"ecoli_in/"+i for i in file_list}}

with open("config_abricate_ecoli.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_ecoli.yaml"

print("Starting abricate workflow")

rule abricate_all:
    input:
        expand("abricateResults/{sample}_abricate_VPECdb.csv", sample = config["samples"]),
        expand("abricateResults/{sample}_abricate_ecoli_vf.csv", sample = config["samples"]),
    shell:
        "cat {input} > ecoli_abricate_all.csv"

rule run_all:
    input:
        lambda wildcards: config["samples"][wildcards.sample]

    params:
        ecoli="ecoli_vf",
        vpec="VPECdb",

    output:
        vpec="abricateResults/{sample}_abricate_VPECdb.csv",
        ecoli="abricateResults/{sample}_abricate_ecoli_vf.csv",

    shell:
        """
        abricate {input} --csv --db {params.vpec} > {output.vpec}
        abricate {input} --csv --db {params.ecoli} > {output.ecoli}
        """
