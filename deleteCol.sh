#!/usr/bin/env bash

# Usage: ./deleteCol.sh input.txt output.txt 3 ","
# This removes the 3rd column from a comma-delimited file

INPUT=$1        # input file
OUTPUT=$2       # output file
COL=$3          # column number to remove (1-based index)
DELIM=$4        # delimiter (e.g., "," or "\t")

awk -v col="$COL" -v FS="$DELIM" -v OFS="$DELIM" '{
    $col=""; sub(FS FS, FS); gsub(/^'"$DELIM"'|'"$DELIM"'$/, "");
    print
}' "$INPUT" > "$OUTPUT"
