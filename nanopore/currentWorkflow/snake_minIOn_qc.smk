cat ./fastq_pass/barcode01/*.fastq > bc01_all.fastq
cat ./fastq_pass/barcode02/*.fastq > bc02_all.fastq
cat ./fastq_pass/barcode03/*.fastq > bc03_all.fastq
cat ./fastq_pass/barcode04/*.fastq > bc04_all.fastq
cat ./fastq_pass/barcode05/*.fastq > bc05_all.fastq
cat ./fastq_pass/barcode06/*.fastq > bc06_all.fastq
cat ./fastq_pass/barcode07/*.fastq > bc07_all.fastq
cat ./fastq_pass/barcode08/*.fastq > bc08_all.fastq
cat ./fastq_pass/barcode09/*.fastq > bc09_all.fastq
cat ./fastq_pass/barcode10/*.fastq > bc10_all.fastq
cat ./fastq_pass/barcode11/*.fastq > bc11_all.fastq
cat ./fastq_pass/barcode12/*.fastq > bc12_all.fastq
cat ./fastq_pass/unclassified/*.fastq > unclassified_all.fastq

mkdir filterlong_in
mv ./fastq_pass/*.fastq ./filterlong_in



#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("filterlong_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"filterlong_in/"+i for i in file_list}}

with open("config_filterlong.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_filterlong.yaml"
rule all:
    input:
        expand("filtlong_out/{sample}_clean.fastq.gz", sample = config["samples"])

rule filtlong:
    input:
        "filterlong_in/{sample}.fastq"
    output:
        name="filterlong_out/{sample}_clean.fastq.gz"
    conda:
        "filtlong_env.yaml"
    shell:
        "filtlong --min_length 500 --keep_percent 95 {input} | gzip > {output.name}"   #### edit min length if not whole bacteria
