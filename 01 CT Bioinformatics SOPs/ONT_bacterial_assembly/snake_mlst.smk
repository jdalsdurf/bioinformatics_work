#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in results/ folder which is output of SPADES snake workflow
for entry in os.scandir("01_assembly_results/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"01_assembly_results/"+i for i in file_list}}

with open("config_mlst.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_mlst.yaml"

print("Starting mlst workflow")

rule all:
    input:
        expand("mlst_results/{sample}_mlst.csv", sample = config["samples"])
    shell:
        "cat {input} > mlst_all.csv"
##### mlst
rule mlst:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        mlst = "mlst_results/{sample}_mlst.csv"
    log:
        "mlst_results/logs/{sample}_mlst.log"
    conda:
        "mlst_env.yaml"
    shell:
        """
		mlst {input} --csv > {output.mlst}
		"""
