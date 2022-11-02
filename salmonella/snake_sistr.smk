#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in results/ folder which is output of SPADES snake workflow
for entry in os.scandir("sistr_in/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"sistr_in/"+i for i in file_list}}

with open("config_sistr.yaml","w") as handle:
    yaml.dump(config_dict,handle)

##### rule all is a general rule that says this is the results we are lookin for in the end.
##### Need to think back to front
configfile: "config_sistr.yaml"

print("Starting sistr workflow")

rule all:
    input:
        expand("sistrResults/general-output/{sample}_sistr-output.csv", sample = config["samples"])
    # shell:
    #     "cat {input} > mlst_all.csv"
##### mlst
rule sistr:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        allele_results = "sistrResults/allele-results/{sample}_allele-results.json",
        novel_alleles = "sistrResults/novel-alleles/{sample}_novel-alleles.fasta",
        cgmlst_profiles = "sistrResults/cgmlst_profiles/{sample}_cgmlst-profiles.csv",
        general = "sistrResults/general-output/{sample}_sistr-output.csv",

    # log:
    #     "sistrResults/logs/{sample}_sistr.log"
    shell:
        """
		sistr --qc -vv --alleles-output {output.allele_results} --novel-alleles {output.novel_alleles} --cgmlst-profiles {output.cgmlst_profiles} -f csv -o {output.general} {input}
		"""
