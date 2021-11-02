#!/bin/bash

# This file should be in the fastq file copied from the nanopore run.
# Saved in a folder on desktop

#### COMMENT OUT THE BARCODES NOT PRESENT OR ERROR WILL OCCURE.
#### NOT CRITICAL BUT WILL GENERATE ERROR

cat ./fastq_pass/barcode01/*.fastq.gz > bc01_all.fastq.gz
cat ./fastq_pass/barcode02/*.fastq.gz > bc02_all.fastq.gz
cat ./fastq_pass/barcode03/*.fastq.gz > bc03_all.fastq.gz
cat ./fastq_pass/barcode04/*.fastq.gz > bc04_all.fastq.gz
cat ./fastq_pass/barcode05/*.fastq.gz > bc05_all.fastq.gz
cat ./fastq_pass/barcode06/*.fastq.gz > bc06_all.fastq.gz
cat ./fastq_pass/barcode07/*.fastq.gz > bc07_all.fastq.gz
cat ./fastq_pass/barcode08/*.fastq.gz > bc08_all.fastq.gz
cat ./fastq_pass/barcode09/*.fastq.gz > bc09_all.fastq.gz
cat ./fastq_pass/barcode10/*.fastq.gz > bc10_all.fastq.gz
cat ./fastq_pass/barcode11/*.fastq.gz > bc11_all.fastq.gz
cat ./fastq_pass/barcode12/*.fastq.gz > bc12_all.fastq.gz
cat ./fastq_pass/unclassified/*.fastq.gz > unclassified_all.fastq.gz

mkdir filterlong_in
mv *.fastq.gz ./filterlong_in
