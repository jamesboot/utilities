#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <bam_file> <cigar_string>"
    echo "Example: $0 reads.bam 76M"
    exit 1
fi

BAM="$1"
TARGET_CIGAR="$2"

# Check dependencies
if ! command -v samtools >/dev/null 2>&1; then
    echo "Error: samtools not found in PATH" >&2
    exit 1
fi

# Count reads that contain the specified CIGAR string
COUNT=$(samtools view "$BAM" | awk -v cigar="$TARGET_CIGAR" '$6 ~ cigar {count++} END {print count+0}')

echo "CIGAR string: $TARGET_CIGAR"
echo "Occurrences : $COUNT"
