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

with open("config_abricate_ssuis_cps.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_abricate_ssuis_cps.yaml"

print("Starting abricate workflow")

rule all:
    input:
        # expand("abricate_ssuis_cps/{sample}_abricate_ssuis_cps.csv", sample = config["samples"])
        expand("abricate_ssuis_results/all_ssuis.csv")
##### Abricate ssuis_cps
rule ssuis_cps:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    params:
        db_ssuis_cps = "ssuis_cps",
        type = "csv"
    output:
        ssuis_cps = "abricate_ssuis_cps/{sample}_abricate_ssuis_cps.csv",
    log:
        "logs/{sample}_ssuis_cps.log"
    shell:
        "abricate {input} --{params.type} --db {params.db_ssuis_cps} 2> {log} > {output.ssuis_cps}"

#### concatination of results
IDS, = glob_wildcards("abricate_ssuis_cps/{id}.csv")

rule concat:
    input:
        expand("abricate_ssuis_cps/{id}.csv", id=IDS)
    output:
        expand("abricate_ssuis_results/all_ssuis.csv")
    shell:
        "cat {input} {output}"
