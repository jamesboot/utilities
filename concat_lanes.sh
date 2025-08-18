#!/usr/bin/env bash

# concat_lanes.sh
# A bash script that merges R1 and R2 reads of the same sample from different lanes that exist in the same directory.

# Argument 1: FASTQ directory containing the reads
# Argument 2: Output directory for merged reads
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <fastq_directory> <output_directory>"
    exit 1
fi

# Directories
FASTQDIR="$1"
OUTDIR="$2"

# Check if the FASTQ directory exists
if [ ! -d "${FASTQDIR}" ]; then
    echo "FASTQ directory does not exist: ${FASTQDIR}"
    exit 1
fi

# Create output directory if it does not exist
mkdir -p ${OUTDIR}

# Merge R1 and R2 reads from different lanes for each sample
for SAMPLE in $(ls ${FASTQDIR} | grep -oP '^[^_]+' | sort -u); do
    # Find all R1 and R2 files for the sample
    R1_FILES=$(ls ${FASTQDIR}/${SAMPLE}*_R1*.fastq.gz)
    R2_FILES=$(ls ${FASTQDIR}/${SAMPLE}*_R2*.fastq.gz)
    # Merge R1 files
    if [ -n "${R1_FILES}" ]; then
        cat ${R1_FILES} > ${OUTDIR}/${SAMPLE}_R1_001.fastq.gz
        echo "Merged R1 reads for sample ${SAMPLE} into ${OUTDIR}/${SAMPLE}_R1_001.fastq.gz"
    else
        echo "No R1 files found for sample ${SAMPLE}"
    fi
    # Merge R2 files
    if [ -n "${R2_FILES}" ]; then
        cat ${R2_FILES} > ${OUTDIR}/${SAMPLE}_R2_001.fastq.gz
        echo "Merged R2 reads for sample ${SAMPLE} into ${OUTDIR}/${SAMPLE}_R2_001.fastq.gz"
    else
        echo "No R2 files found for sample ${SAMPLE}"
    fi
done

# Notify user of completion
echo "Merging of reads completed. Merged files are located in ${OUTDIR}."
exit 0