#!/bin/bash

# The objective is to count sequences from species of interest in Homologs Groups

groups=$(cat "$1")
rm Count.out
rm Count2.out
rm Count3.out

for group in $groups
do
        Var1=$(egrep emu $group | wc | awk '{print $1}')
        echo $group $Var1 >> Count.out
        Var3=$(egrep mcorti $group | wc | awk '{print $1}')
        echo $group $Var3 >> Count2.out
        Var4=$(egrep hmic $group | wc | awk '{print $1}')
        echo $group $Var4 >> Count3.out
done

Var2=$(awk '{sum += $2} END {print sum}' Count.out)
echo There are $Var2 genes from E. multilocularis in the 33 Homologs Groups
Var5=$(awk '{sum += $2} END {print sum}' Count2.out)
echo There are $Var5 genes from M. corti in the 33 Homologs Groups
Var6=$(awk '{sum += $2} END {print sum}' Count3.out)
echo There are $Var6 genes from H. microstoma in the 33 Homologs Groups

