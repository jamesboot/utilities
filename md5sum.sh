#!/bin/bash
# Simple SLURM sbatch example
#SBATCH --job-name=cpFiles
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:00
#SBATCH --mem-per-cpu=4
#SBATCH --partition=ncpu

# Directory to process
DIR=/nemo/lab/bauerd/home/shared/bootj/mears_et_al_fastq

# Output file for MD5 checksums
CHECKSUM_FILE=$DIR/checksums.md5

# Log
echo "Generating MD5 checksums for files in $DIR..."

# Clear the checksum file if it exists
> "$CHECKSUM_FILE"

# Loop through all files in the directory
for file in "$DIR"/*; do
    if [[ -f "$file" ]]; then
        md5sum "$file" >> "$CHECKSUM_FILE"
    fi
done
echo "Checksums saved to $CHECKSUM_FILE."