#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("trimmed/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"trimmed/"+i for i in file_list}}

with open("config_unicycler.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_unicycler.yaml"

print("Starting Unicycler analysis workflow")

rule all:
    input:
        expand("unicyclerOut/{sample}_unicyclerOut", sample = config["samples"])

#### running unicycler
rule spades:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        directory("unicyclerOut/{sample}_unicyclerOut")
    shell:
        "unicycler -s {input} -o {output}"
