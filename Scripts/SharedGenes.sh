#!/bin/bash

# The goal of this script is to make a list of shared genes between the tegument of H. microstoma, M. corti and E.multilocularis, grouped by homologous groups

Var1=$(cat "$1") # The list of groups I want to analyze (in this case there are 33 groups)
rm CodesHmMcEmu.out
rm GenesHmMcEmu.out

for group in $Var1
do
        egrep 'mcorti|hmic|emu' $group | awk '{print $1}' | awk -F ">" '{print $2}' > CodesHmMcEmu.out # Extracts the codes of the species of interest
        echo $group >> GenesHmMcEmu.out
        
        Var3=$(cat CodesHmMcEmu.out)
        for gene in $Var3
        do
                if [[ "$gene" =~ hmic ]] # If the gene contains 'hmic'...
                then
                        egrep -w $gene "$2" >> GenesHmMcEmu.out # Path to equivalence file (EquivalenceTables/equivalence_hm)
                fi
                if [[ "$gene" =~ emu ]] # If the gene does not contain hmic but does contain emu...
                then
                        egrep -w $gene "$3" >> GenesHmMcEmu.out # Path to equivalence file (EquivalenceTables/equivalence_emu)
                else 
                        egrep -w $gene "$4" >> GenesHmMcEmu.out # Path to equivalence file (EquivalenceTables/equivalence_mc)
                fi
        done
done