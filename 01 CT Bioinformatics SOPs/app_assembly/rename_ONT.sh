#!/bin/bash

for i in *.fastq.gz ; do
        mv "$i" "${i%%_b*}_ont.fastq.gz"
done
