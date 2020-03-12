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

with open("config_kraken.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_kraken.yaml"

print("Starting kraken2 workflow")

rule all:
    input:
        expand("kraken_subset/{sample}_krakenSubset.fasta", sample = config["samples"])

rule kraken subset:
	input:
		fa = lambda wildcards: config["samples"][wildcards.sample],
		kf = "kraken/{sample}.kraken",
	params:
		tax = "694014",
	output:
		"kraken_subset/{sample}_krakenSubset.fasta"
	shell:
		"~/KrakenTools/extract_kraken_reads.py -k {input.kf} -s {input.fa} -o {output} -t {params.tax}"

rule kraken2:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        k = "kraken/{sample}.kraken",
        r = "report_kraken/{sample}.report.txt",
    shell:
        "kraken2 --use-names --db ~/kraken2/defaultDB --report {output.r} {input} > {output.k}"
