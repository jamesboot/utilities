#!/usr/bin/env bash

# gtf2gff.sh
# Script to convert GTF files to GFF format using StringTie

# Argument 1: Input GTF file
# Argument 2: Output GFF file
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input.gtf> <output.gff>"
    exit 1
fi

# Load the required modules
ml purge
ml gffread/0.11.6-GCCcore-9.3.0

# Define input and output files
input_gtf="$1"
output_gff="$2"

# Convert GTF to GFF using gffread
gffread $input_gtf -o $output_gff