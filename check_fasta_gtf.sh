#!/bin/bash

# Usage: ./check_fasta_gtf.sh genome.fasta[.gz] annotations.gtf[.gz]

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <fasta_file(.gz)> <gtf_file(.gz)>"
    exit 1
fi

FASTA="$1"
GTF="$2"

# Function to select the appropriate file reader (gzip-compatible)
read_file() {
    local file="$1"
    if [[ "$file" == *.gz ]]; then
        gzip -dc "$file"
    else
        cat "$file"
    fi
}

# Extract sequence names from FASTA (remove '>' and take first word)
fasta_seqs=$(read_file "$FASTA" | grep '^>' | sed 's/^>//' | cut -d' ' -f1 | sort -u)

# Extract unique sequence names from GTF (first column, skip comments)
gtf_seqs=$(read_file "$GTF" | grep -v '^#' | cut -f1 | sort -u)

# Compare the two lists
missing=0
echo "Checking for missing sequence names..."
for seq in $fasta_seqs; do
    if ! grep -q "^$seq$" <<< "$gtf_seqs"; then
        echo "Missing in GTF: $seq"
        ((missing++))
    fi
done

if [[ $missing -eq 0 ]]; then
    echo "✅ All FASTA sequence names are present in the GTF file."
else
    echo "❌ $missing sequence name(s) from the FASTA file are missing in the GTF."
fi