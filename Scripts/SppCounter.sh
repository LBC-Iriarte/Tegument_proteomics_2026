#!/bin/bash

# The goal of this script is to find, among the homologs groups (output files from get_homologues), those that have sequences from the species I want
# Argument 1 is a file with the list of species (codes) that I need to search for

hom_groups=$(cat "$1") # Lists all output files from get_homologues
species=$(cat "$2") # Reads the argument, which is the file with the species I'm interested in
rm CountSearchedSpecies.out

for group in $hom_groups # Takes each file from the output list
do
        i=0 # Defines variable i, which will add 1 each time it finds a species from the argument
        echo "$group" 
        for sp in $species # Takes each species from the argument...
        do 	
        	CheckExistsVar=$(egrep "$sp" "$group" | wc | awk '{print $1}') # Defines the check variable, which searches for each species from the argument in each file, counts it, and reads that number
        	if [ $CheckExistsVar -gt 0 ] # If the check variable is greater than 0...
        	then
    			let i=i+1 # ...adds 1 to variable i, which reflects how many species are in each output file
    		fi    
    	done # Closes the loop for species from the argument
    	echo the number of species found in $group is $i # Prints the number of species found in each output file
    	echo $group $i >> CountSearchedSpecies.out # Saves to the file the names of the files with the number of species they contain next to them
done      
egrep -w -v "0"$ CountSearchedSpecies.out > TotalIDGroupsWithHm.lis

exit