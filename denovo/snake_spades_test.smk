#### this passes all fastq files to the following programs
import os
import yaml

file_list = []
### location assumes that data is in relabeled_reads/ibv/ folder
for entry in os.scandir("/mnt/y/Ion_Torrent_Experiments/20200123/relabeld_reads/prrs/"):
    if entry.is_file():
        file_list.append(entry.name)
#### this tells where data is that will be used for dictionary
config_dict = {"samples":{i.split(".")[0]:"/mnt/y/Ion_Torrent_Experiments/20200123/relabeld_reads/prrs/"+i for i in file_list}}

with open("config_spades.yaml","w") as handle:
    yaml.dump(config_dict,handle)
