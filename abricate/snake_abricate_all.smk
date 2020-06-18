#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in fasta_input/ folder which is output of SPADES snake workflow
for entry in os.scandir("fasta_input/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"fasta_input/"+i for i in file_list}}

with open("config_abricate_argannot.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_argannot.yaml"

print("Starting abricate workflow")

rule abricate_all:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
params:
    argannot = "argannot",
    ncbi = "ncbi"
    resfinder="resfinder"
    vfdb="vfdb"
    card="card"
    megares="megares"
    csv="csv"
output:
    argannot = "abricateResults/{sample}_abricate_argannot.csv",
    ncbi = "abricateResults/{sample}_abricate_ncbi.csv",
    resfinder="abricateResults/{sample}_abricate_resfinder.csv",
    vfdb="abricateResults/{sample}_abricate_vfdb.csv",
    card="abricateResults/{sample}_abricate_card.csv",
    megares="abricateResults/{sample}_abricate_megares.csv",
run:
    shell(abricate {input} --csv --db {params.argannot} > {output.argannot}),
    shell(abricate {input} --csv --db {params.ncbi} > {output.ncbi}),
    shell(abricate {input} --csv --db {params.resfinder} > {output.resfinder}),
    shell(abricate {input} --csv --db {params.vfdb} > {output.vfdb}),
    shell(abricate {input} --csv --db {params.card} > {output.card}),
    shell(abricate {input} --csv --db {params.megares} > {output.megares}),
rule cat_csv:
    input:
        "abricateResults/{sample}_abricate_argannot.csv",
