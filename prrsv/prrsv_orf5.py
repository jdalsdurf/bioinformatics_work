# This is a script to do restriction enzyme anaylsis of ORF5 in PRRSV using the
# following restricetion enzymes MluI, HincII, and SacII.

import sys
import rflp
from Bio import SeqIO
from Bio.Restriction import Restriction
from Bio.Restriction import Analysis


def find_key(dictionary, value):
	for key, values in dictionary.items():
		if value == values:
			return key


orfSeq = ()
with open(sys.argv[1],"r") as fasta_file:
	for record in SeqIO.parse(fasta_file,"fasta"):
		orfSeq = record.seq

mlui = Restriction.MluI.search(orfSeq)
hincii = Restriction.HincII.search(orfSeq)
sacii = Restriction.SacII.search(orfSeq)

mluiRFLP = find_key(rflp.rflpMluI, mlui)
hinciiRFLP = find_key(rflp.rflpHincII, hincii)
saciiRFLP = find_key(rflp.rflpSacII, sacii)

print(sys.argv[1].split(".")[0], " ", "RFLP " ,mluiRFLP,"-",hinciiRFLP,"-",saciiRFLP, sep="")
