#!/bin/bash

# Script to find R1 and R2 for all samples in project and save to CSV
# Usage: ./samplesheet.sh -d <directory> [-n] [-o output.csv]
# -d: Directory to search in
# -n: No header in output CSV
# -o: Output file name (default: samplesheet.csv)

usage() {
    echo "Usage: $0 -d <directory> [-n] [-o output.csv] [-1 R1_suffix] [-2 R2_suffix]"
    echo "  -d: Directory to search in (required)"
    echo "  -n: No header in output CSV"
    echo "  -o: Output file name (default: samplesheet.csv)"
    echo "  -1: Suffix pattern for R1 files (default: R1_001.fastq)"
    echo "  -2: Suffix pattern for R2 files (default: R2_001.fastq)"
    exit 1
}


# Default values
output_file="samplesheet.csv"
include_header=true
search_dir=""
R1_suffix="R1_001.fastq"
R2_suffix="R2_001.fastq"


# Parse command line arguments
while getopts "d:no:1:2:" opt; do
    case $opt in
        d) search_dir="$OPTARG" ;;
        n) include_header=false ;;
        o) output_file="$OPTARG" ;;
        1) R1_suffix="$OPTARG" ;;
        2) R2_suffix="$OPTARG" ;;
        ?) usage ;;
    esac
done

# Check if directory is provided
if [ -z "$search_dir" ]; then
    echo "Error: Directory must be specified with -d option"
    usage
fi

# Check if directory exists
if [ ! -d "$search_dir" ]; then
    echo "Error: Directory '$search_dir' does not exist"
    exit 1
fi

# Create temporary files
temp_dir=$(mktemp -d)
r1_file="$temp_dir/r1.txt"
r2_file="$temp_dir/r2.txt"
r1_sort="$temp_dir/r1_sort.txt"
r2_sort="$temp_dir/r2_sort.txt"


# Find R1 and R2 files (support custom suffixes and both gzipped/non-gzipped)
find -L "$search_dir" -type f \( -name "*${R1_suffix}.gz" -o -name "*${R1_suffix}" \) > "$r1_file"
find -L "$search_dir" -type f \( -name "*${R2_suffix}.gz" -o -name "*${R2_suffix}" \) > "$r2_file"

# Check if any files were found
if [ ! -s "$r1_file" ]; then
    echo "Error: No R1 fastq files found in '$search_dir'"
    rm -rf "$temp_dir"
    exit 1
fi

# Sort the files
sort "$r1_file" > "$r1_sort"
sort "$r2_file" > "$r2_sort"

# Create CSV for results
if [ -f "$output_file" ]; then
    echo "Warning: Output file '$output_file' already exists. It will be overwritten."
    rm "$output_file"
fi

# Add header if requested
if $include_header; then
    echo "sample,fastq_1,fastq_2" > "$output_file"
fi

# Process each pair of files
while IFS= read -r R1 <&3 && IFS= read -r R2 <&4; do
    # Verify R2 file exists and matches R1
    if [ ! -f "$R2" ]; then
        echo "Warning: Missing R2 file for $R1"
        continue
    fi
    
    # Get basename and extract sample ID (everything before first underscore)
    BASE=$(basename "$R1")
    ID="${BASE%%_*}"
    
    # Write to CSV
    echo "$ID,$R1,$R2" >> "$output_file"
done 3<"$r1_sort" 4<"$r2_sort"

# Clean up
rm -rf "$temp_dir"

echo "Samplesheet has been created: $output_file"