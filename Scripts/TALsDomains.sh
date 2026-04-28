#!/bin/bash

# The objective of the script is to extract the protein domains present in Tegument Antigen Like (TAL) proteins

GFF_FILE="$1"  # Argument 1: .gff file with annotations for each gene
TALS=$(cat "$2") # Argument 2: list of gene codes of TAL proteins
rm -f Domains.out

for TAL in $TALS
do
    Var=$(egrep $TAL $GFF_FILE | egrep InterPro | egrep -o "IPR[0-9][0-9A-Z]*")
    echo $TAL $Var >> Domains.out # The output is a list table with each TAL gene along with its protein domains
done
exit