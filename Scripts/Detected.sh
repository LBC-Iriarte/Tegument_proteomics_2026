#!/bin/bash

# The objective of this script is to count Homologs Groups (HGs) that contain:
#      - Proteins detected by proteomics in one species
#      - Proteins detected in one species with an homolog in the other species
#      - Proteins detected in one species with an homolog detected in the other species as well

# Arguments:
# $1: List of groups with proteins detected by proteomics for one species
# $2: Text file with a specie that is not being analized (e.g hmic)
# $3: List of proteins identified by proteomics
# $4: List with groups of proteins identified by proteomics with the number of identified proteins next to each group

groups=$(cat "$1") # Argument: list of groups with proteins idetified by proteomics in H. microstoma or M. corti
spp=$(cat "$2") # Argument: species that is being searched for (if previous argument is a H. microstoma list, this will be 'mcorti' and viceversa)

rm intermediate.out
rm intermediate2.out
rm intermediate3.out
rm codes1

for group in $groups 
do
        Var1=$(egrep $spp $group | wc -l | awk '{print $1}') # Searches for the species in the group
	echo $group $Var1 >> intermediate.out # Prints the name of the group and how many times does the species appear
done
egrep -w -v "0"$ intermediate.out > GroupsWithBoth # Generates a list with groups containing both species and how many times each species appeares

################################################################################################################################################################

awk '{print $1}' GroupsWithBoth > GroupsWithBoth.lis # Keep only the name of the groups
Print1=$(wc -l GroupsWithBoth.lis | awk '{print $1}')
echo Detected with $spp homolog: $Print1 groups

Variable1=$(cat GroupsWithBoth.lis)

for group in $Variable1 # Search for the species in the groups and saves the codes in the 'codes1' file
do
	egrep $spp $group >> codes1
done

sed 's/>//g' codes1 | awk '{print $1}' > codes"$spp".out # 'Cleaning' of the codes


Variable2=$(cat codes"$spp".out)
rm codes"$spp"Detected.out

for cod in $Variable2 # Look for the codes from the species to see which were identified by proteomics
do
	egrep -w $cod "$3" >> codes"$spp"Detected.out
done
	
Variable3=$(cat codes"$spp"Detected.out)

for group in $groups # Searches for the groups containing the codes for proteins identified by proteomics in the species
do
	i=0
	for code in $Variable3
	do
		Check=$(egrep -w $code $group | wc | awk '{print $1}')
		if [ $Check -gt 0 ]
		then
			let i=i+1
		fi
	done
	echo $group $i >> intermediate2.out # List of groups and how many detected proteins of the species contains 
done
egrep -w -v "0"$ intermediate2.out > groupswith"$spp"Detected # Keeps only groups with proteins identified by proteomics from the species and the quantity of proteins next to it

awk '{sum+=$2;} END{print sum;}' groupswith"$spp"Detected > DetectedSpp	
Print2=$(wc -l groupswith"$spp"Detected | awk '{print $1}')

Print2b=$(cat DetectedSpp)
echo Proteins of $spp detected by proteomics: $Print2b	
	
#######################################################

awk '{print $1}' groupswith"$spp"Detected > groupswith"$spp"Detected.lis
Variable4=$(cat groupswith"$spp"Detected.lis)

for gru in $Variable4 #  To count how many proteins have a detected homolog in the other specie
do
	egrep $gru "$4" >> intermediate3.out 
done
awk '{sum+=$2;} END{print sum;}' intermediate3.out > ProteinsWithDetectedHomolog
Print3=$(cat ProteinsWithDetectedHomolog)
echo The amount of detected proteins with an homolog from $spp detected is: $Print3
echo Detected proteins with $spp homolog detected: $Print2 groups