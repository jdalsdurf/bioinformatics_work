#!/bin/bash
cat ./fastq_pass/barcode01/*.fastq > ./fastq_pass/bc01_all.fastq
cat ./fastq_pass/barcode02/*.fastq > ./fastq_pass/bc02_all.fastq
cat ./fastq_pass/barcode03/*.fastq > ./fastq_pass/bc03_all.fastq
cat ./fastq_pass/barcode04/*.fastq > ./fastq_pass/bc04_all.fastq
cat ./fastq_pass/barcode05/*.fastq > ./fastq_pass/bc05_all.fastq
cat ./fastq_pass/barcode06/*.fastq > ./fastq_pass/bc06_all.fastq
cat ./fastq_pass/barcode07/*.fastq > ./fastq_pass/bc07_all.fastq
cat ./fastq_pass/barcode08/*.fastq > ./fastq_pass/bc08_all.fastq
cat ./fastq_pass/barcode09/*.fastq > ./fastq_pass/bc09_all.fastq
cat ./fastq_pass/barcode10/*.fastq > ./fastq_pass/bc10_all.fastq
cat ./fastq_pass/barcode11/*.fastq > ./fastq_pass/bc11_all.fastq
cat ./fastq_pass/barcode12/*.fastq > ./fastq_pass/bc12_all.fastq

mkdir filterlong_in
mv ./fastq_pass/*.fastq ./filterlong_in
