#!/bin/bash

for i in *.fastq ; do
        mv "$i" "${i%%_*}.fastq"
done
