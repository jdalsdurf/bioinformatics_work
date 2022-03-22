#!/bin/bash

for i in *R2* ; do
        mv "$i" "${i%%_S*}_R2.fastq.gz"
done
