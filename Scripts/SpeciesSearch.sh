#!/bin/bash

# The goal of this script is to search for proteins identified by proteomics in homologous groups and list those groups that contain tegumentary proteins

hom_groups=$(cat "$1") # Path to the list of homologs groups to explore
proteins1=$(cat "$2") # Reads the argument, which is the file with the codes of proteins identified by proteomics for a given species

rm ProteinCount.out

for group in $hom_groups # Takes each file from the output list
do
        i=0
        echo "$group" 
        for prot1 in $proteins1 # Takes each code from argument1...
        do      
                CheckExistsVar=$(egrep -w "$prot1" "$group" | wc | awk '{print $1}') # Defines the check variable, which searches for each code from the argument in each file, counts it, and reads that number
                if [ $CheckExistsVar -gt 0 ] # If the check variable is greater than 0...
                then
                        let i=i+1 # ...adds 1 to variable i, which reflects how many proteins are in each output file
                fi 
        done 
        echo $group $i >> ProteinCount.out # Saves to the file the names of the files with the number of proteins they contain next to them
done      
egrep -v -w "0"$ ProteinCount.out > GroupsWithTotalID.out # Creates a file with the names of all output files that have at least 1 protein from the species being searched