### concatinate all mapped_reads
# cat ./barcode01/*.fastq > bc01_all.fastq
# cat ./barcode02/*.fastq > bc02_all.fastq
# cat ./barcode03/*.fastq > bc03_all.fastq
# cat ./barcode04/*.fastq > bc04_all.fastq
# cat ./barcode05/*.fastq > bc05_all.fastq
# cat ./barcode06/*.fastq > bc06_all.fastq
# cat ./barcode07/*.fastq > bc07_all.fastq
# cat ./barcode08/*.fastq > bc08_all.fastq
# cat ./barcode09/*.fastq > bc09_all.fastq
# cat ./barcode10/*.fastq > bc10_all.fastq
# cat ./barcode11/*.fastq > bc11_all.fastq
# cat ./barcode12/*.fastq > bc12_all.fastq
# mkdir porechop_in
# mv *.fastq ./porechop_in

#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("porechop_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"porechop_in/"+i for i in file_list}}

with open("config_porechop.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_porechop.yaml"
rule all:
    input:
        expand("filtlong_out/{sample}_clean.fastq.gz", sample = config["samples"])

rule porechop:
    input:
        "porechop_in/{sample}.fastq"
    output:
        name="porechop_out/{sample}_porechopOut.fastq"

    conda:
        "porechop.yaml"  ###### need to have env file in folder

    shell:
        "porechop -i {input} -o {output.name} -t 32 --barcode_threshold 85 --require_two_barcodes"

rule filtlong:
    input:
        "porechop_out/{sample}_porechopOut.fastq"
    output:
        name="filtlong_out/{sample}_clean.fastq.gz"
    conda:
        "filtlong_env.yaml"
    shell:
        "filtlong --min_length 1000 --keep_percent 95 {input} | gzip > {output.name}"
