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
        expand("abricateResults/{sample}_abricate_argannot.csv", sample = config["samples"]),
        expand("abricateResults/{sample}_abricate_ncbi.csv", sample = config["samples"]),
        expand("abricateResults/{sample}_abricate_resfinder.csv", sample = config["samples"]),
        expand("abricateResults/{sample}_abricate_vfdb.csv", sample = config["samples"]),
        expand("abricateResults/{sample}_abricate_card.csv", sample = config["samples"]),
        expand("abricateResults/{sample}_abricate_megares.csv", sample = config["samples"]),
        expand("abricateResults/{sample}_abricate_ssuis.csv", sample = config["samples"]),
    shell:
        "cat {input} > abricate_all.csv"

rule run_all:
    input:
        lambda wildcards: config["samples"][wildcards.sample]

    params:
        argannot = "argannot",
        ncbi = "ncbi",
        resfinder="resfinder",
        vfdb="vfdb",
        card="card",
        megares="megares",
        csv="csv",
        ssuis="ssuis"

    output:
        argannot = "abricateResults/{sample}_abricate_argannot.csv",
        ncbi = "abricateResults/{sample}_abricate_ncbi.csv",
        resfinder="abricateResults/{sample}_abricate_resfinder.csv",
        vfdb="abricateResults/{sample}_abricate_vfdb.csv",
        card="abricateResults/{sample}_abricate_card.csv",
        megares="abricateResults/{sample}_abricate_megares.csv",
        ssuis="abricateResults/{sample}_abricate_ssuis.csv",

    shell:
        """
        abricate {input} --csv --db {params.argannot} > {output.argannot}
        abricate {input} --csv --db {params.ncbi} > {output.ncbi}
        abricate {input} --csv --db {params.resfinder} > {output.resfinder}
        abricate {input} --csv --db {params.vfdb} > {output.vfdb}
        abricate {input} --csv --db {params.card} > {output.card}
        abricate {input} --csv --db {params.megares} > {output.megares}
        abricate {input} --csv --db {params.ssuis} > {output.ssuis}

        """
