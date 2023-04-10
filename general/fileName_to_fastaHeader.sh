#!/bin/bash

for f in *.fasta ; do 
	sed -i "s/^>/>${f%.fasta}_/g" "${f}"
done