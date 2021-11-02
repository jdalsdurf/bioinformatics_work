#!/bin/bash
cp -r ../irmaOut_SIV/fasta_files/ ./

for i in ./fasta_files/*.fasta ; do
        ./octoFLU.sh "$i"
done
