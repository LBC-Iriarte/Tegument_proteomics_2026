#!/bin/bash

# The objective of the script is to find the homologs groups that contain sequences from the species of interest
# Argument $1 is a list of species to search for (e.g hmic for H. microstoma)

HGs=$(cat "$1") # Lists all homologs groups
spp=$(cat "$2") # Argument is the list with cestodes species of interest
spp2=$(cat "$3") # Argument is the list with trematode specie of interest 

rm CountSppCT.out
rm CountSppCestodesOnly.out

for group in $HGs 
do
        i=0 
        j=0
        for sp in $spp 
        do 	
 	       	VarCheck=$(egrep "$sp" "$group" | wc | awk '{print $1}')  
        	if [ $VarCheck -gt 0 ] 
        	then
    			let i=i+1
    		fi    
    	done
	for sp2 in $spp2
	do
		Var2=$(egrep "$sp2" "$group" | wc | awk '{print $1}')
		if [ $Var2 -gt 0 ]
		then
			let j=j+1
		fi
	done
	if [ $j -gt 0 ]
	then
		echo $grupo $i $j >> CountSppCT.out
	fi
	if [ $j == 0 ] && [ $i -gt 1 ]
        then
                echo $group $i >> CountSppCestodesOnly.out
        fi 

done      

exit
