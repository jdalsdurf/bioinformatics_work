#!/bin/bash
cp -r ../irmaOut_SIV/merged/ ./

for i in ./merged/*.fasta ; do
        ./octoFLU.sh "$i"
done
