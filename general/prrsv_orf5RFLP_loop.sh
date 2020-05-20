#!/bin/bash

for i in *.fasta ; do
        python prrsv_orf5.py $i > ${i%%_}_orf5RFLP.csv
done
