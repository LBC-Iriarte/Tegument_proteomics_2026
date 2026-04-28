#!/bin/bash

# The goal of this AI generated script is to search for proteins identified by proteomics
# within homologs groups (HGs) and list those groups

# Input variables
homologous_groups=(*.faa)  # List all .faa files (HGs)
proteins_file="$1" # Path to the list of proteins identified by proteomics

# Output files
count_output="ProtCountSearchedTeg.out"
result_output="NonEnrichedTegumentGroups.out"

# Remove previous files if they exist
rm -f "$count_output" "$result_output"

# Verify that the proteins file exists
if [[ ! -f "$proteins_file" ]]; then
    echo "Error: File $proteins_file not found" >&2
    exit 1
fi

# Create a unique search pattern for grep (main optimization)
# This creates a pattern like: prot1|prot2|prot3|...
pattern=$(tr '\n' '|' < "$proteins_file" | sed 's/|$//')

if [[ -z "$pattern" ]]; then
    echo "Error: Proteins file is empty" >&2
    exit 1
fi

# Process each homologs group
for group in "${homologous_groups[@]}"; do
    echo "Processing: $group"

    # Search for all proteins from the file in the group using a single grep
    # -c counts matches, -E for extended expression, -w for whole words
    count=$(grep -E -w "$pattern" "$group" | wc -l)

    # Only write if there are matches
    if [[ $count -gt 0 ]]; then
        echo "$group $count" >> "$count_output"
    fi
done

# Create final file (now only contains groups with at least 1 protein)
if [[ -f "$count_output" ]]; then
    cp "$count_output" "$result_output"
    echo "Process completed. Results in: $result_output"
else
    echo "No matches found in any group."
fi