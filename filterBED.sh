#!/usr/bin/env bash

# Script to filter out specific chromosomes from a BED file
# Usage: ./filterBED.sh input.bed output.bed "chrM chrUn chrEBV"

# Arguments
INPUT=$1
OUTPUT=$2
REMOVE_CHRS=$3

# Convert the list of chromosomes to a regex pattern like: ^(chrM|chrUn|chrEBV)$
PATTERN=$(echo $REMOVE_CHRS | sed 's/ /|/g')

# Filter the BED file
# Keep only lines whose chromosome (first column) does NOT match the pattern
awk -v pat="^(${PATTERN})$" 'BEGIN{OFS="\t"} !($1 ~ pat)' "$INPUT" > "$OUTPUT"
