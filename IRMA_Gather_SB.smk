## converting IRMA output into Bionumerics import format

import os
import sys
import glob
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
from Bio import SeqIO


##Find Files in Directory
fa_list = [i for i in glob.glob("*.fa")]

## IRMA output is 1-8 while db uses gene names
SeqDict = {"1":"PB2","2":"PB1","3":"PA","4":"HA","5":"NP","6":"NA","7":"M","8":"NS"}

basename = fa_list[0].split("_")
new_fa_file = basename[0]+"_"+"All_Segments.fa"

def Windows_Or_Linux():
    if os.name=="nt":
        return 'wb'
    else:
        return 'w'

with open(new_fa_file,Windows_Or_Linux()):
    records = []
    for i in fa_list:
        file = i.split("_")
        new_header = SeqDict[file[2].split(".")[0]]
        for seq in SeqIO.parse(i, "fasta"):
            segment = seq.seq
            record = SeqRecord(Seq(segment), id = new_header, description = "| "+ basename[0])
            records.append(record)
    SeqIO.write(records, new_fa_file, "fasta")
