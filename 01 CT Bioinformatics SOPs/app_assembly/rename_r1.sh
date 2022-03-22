#!/bin/bash

for i in *R1* ; do
        mv "$i" "${i%%_S*}_R1.fastq.gz"
done
