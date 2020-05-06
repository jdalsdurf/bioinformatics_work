#!/bin/bash

for i in *.gff ; do
        mv "$i" "${i%%_*}.gff"
done
