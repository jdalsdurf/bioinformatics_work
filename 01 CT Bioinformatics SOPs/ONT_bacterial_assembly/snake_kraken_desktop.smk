#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in kraken_in/ folder which is output of SPADES snake workflow
for entry in os.scandir("01_assembly_results/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"01_assembly_results/"+i for i in file_list}}

with open("config_kraken.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_kraken.yaml"

print("Starting kraken2 workflow")

rule all:
    input:
#        expand("kraken_subset/{sample}_ssuis_krakenSubset.fasta", sample = config["samples"]),
        expand("kraken/{sample}.kraken.txt", sample = config["samples"]),
        expand("report_kraken/{sample}.report.txt", sample = config["samples"]),
        expand("kraken_classified/{sample}_classified.fasta", sample = config["samples"]),

# rule kraken subset:
# 	input:
# 		fa = lambda wildcards: config["samples"][wildcards.sample],
# 		kf = "kraken/{sample}.kraken.txt",
# 	params:
# 		tax = "1307",
# 		report = "report_kraken/{sample}.report.txt"
# 	output:
# 		"kraken_subset/{sample}_ssuis_krakenSubset.fasta"
# 	shell:
# 		"/mnt/s/bioinformatics/databases/kraken2/KrakenTools/extract_kraken_reads.py -k {input.kf} -s {input.fa} -o {output} -t {params.tax} --include-children -r {params.report} "

rule kraken2:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        k = "kraken/{sample}.kraken.txt",
        r = "report_kraken/{sample}.report.txt",
        cl = "kraken_classified/{sample}_classified.fasta"

    # conda:
    #     "kraken2_env.yaml"
    shell:
        "kraken2 --use-names --db /run/user/1000/gvfs/afp-volume:host=RNDNAS.local,user=jalsdurf,volume=Sequencing/bioinformatics/databases/kraken2 --threads 8 --quick --memory-mapping --classified-out {output.cl} --report {output.r} {input} > {output.k}"
###
#kraken2 --use-names --db /run/user/1000/gvfs/afp-volume:host=RNDNAS.local,user=jalsdurf,volume=Sequencing/bioinformatics/databases/kraken2 --threads 8 --quick --memory-mapping --classified-out {output.cl} --report {output.r} {input} > {output.k}
###

### avibacterium 728
### S.suis 1307
### reovirus 38170
### h.parasuis 738
### mycoplasma bovis 28903
### Moraxella bovoculi 386891 extension _mxBovoc
