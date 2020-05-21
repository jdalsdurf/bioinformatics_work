#!/bin/bash

for i in *.fasta ; do
        python prrsv_orf5.py $i > ${i%%._ORF5.fasta}_orf5RFLP.csv
done
