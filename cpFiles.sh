#!/bin/bash
# Simple SLURM sbatch example
#SBATCH --job-name=cpFiles
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:00
#SBATCH --mem-per-cpu=4
#SBATCH --partition=ncpu

# Script to copy a list of files to a specified folder

# Define the path to the file_list file 
file_list=/nemo/lab/bauerd/home/shared/bootj/files.txt

# Define full path of destination folder
destination=/nemo/lab/bauerd/home/shared/bootj/mears_et_al_fastq/

# Copy each file in the list to the destination
while IFS= read -r file; do
    if [ -n "$file" ]; then # Ensure the file path is not empty
        if [ -f "$file" ]; then
            echo "Copying '$file' to '$destination'"
            cp "$file" "$destination"
        else
            echo "Warning: File '$file' does not exist. Skipping."
        fi
    fi
done < "$file_list"