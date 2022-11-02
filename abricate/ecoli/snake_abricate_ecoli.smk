#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in mlst_in/ folder which is output of SPADES snake workflow
for entry in os.scandir("mlst_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"mlst_in/"+i for i in file_list}}

with open("config_abricate_argannot.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_argannot.yaml"

print("Starting abricate workflow")

rule abricate_all:
    input:
        expand("abricateResults/{sample}_abricate_VPECdb.csv", sample = config["samples"]),
        expand("abricateResults/{sample}_abricate_ecoli_vf.csv", sample = config["samples"]),

    shell:
        "cat {input} > abricate_all.csv"

rule run_all:
    input:
        lambda wildcards: config["samples"][wildcards.sample]

    params:
        ecoli="VPECdb",
        ecoli_vf="ecoli_vf"

    output:
        # ecoli="abricateResults/{sample}_abricate_ecoli_VPEC.csv",
        ecoli_vf="abricateResults/{sample}_abricate_ecoli_vf.csv",
        ecoli="abricateResults/{sample}_abricate_VPECdb.csv"

    shell:
        """
        abricate {input} --csv --db {params.ecoli} > {output.ecoli}
        abricate {input} --csv --db {params.ecoli_vf} > {output.ecoli_vf}
        """
