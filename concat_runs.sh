#!/usr/bin/env bash

# A bash script to concatenate reads from two different samplesheets into a single set of reads.
# It will save concatenated reads to specified output directory along with new samplesheet.csv

# Argument 1: Path to the first samplesheet
# Argument 2: Path to the second samplesheet
# Argument 3: Output directory for concatenated reads
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <samplesheet1.csv> <samplesheet2.csv> <output_directory>"
    exit 1
fi

# Directories
SHEET1="$1"
SHEET2="$2"
OUTDIR="$3"

# Check if the samplesheets exist
if [[ ! -f ${SHEET1} ]] || [[ ! -f ${SHEET2} ]]; then
    echo "One or both samplesheets do not exist."
    exit 1
fi

# Check if the sample sheets have the sample number of lines
LINES1=$(wc -l < ${SHEET1})
LINES2=$(wc -l < ${SHEET2})
if [[ ${LINES1} -ne ${LINES2} ]]; then
    echo "The samplesheets have different number of lines."
    exit 1
fi

# Create output directory if it does not exist
mkdir -p ${OUTDIR}

# For loop through the number of lines in the samplesheets
for i in $(seq 1 ${LINES1}); do
    # Read the sample names and read files from both sheets
    SAMPLE1=$(sed -n "${i}p" ${SHEET1} | cut -d ',' -f 1)
    R1_1=$(sed -n "${i}p" ${SHEET1} | cut -d ',' -f 2)
    R2_1=$(sed -n "${i}p" ${SHEET1} | cut -d ',' -f 3)
    SAMPLE2=$(sed -n "${i}p" ${SHEET2} | cut -d ',' -f 1)
    R1_2=$(sed -n "${i}p" ${SHEET2} | cut -d ',' -f 2)
    R2_2=$(sed -n "${i}p" ${SHEET2} | cut -d ',' -f 3)
    # Remove all characters after the first underscore in the sample name
    SAMPLE1=$(echo ${SAMPLE1} | cut -d '_' -f 1)
    SAMPLE2=$(echo ${SAMPLE2} | cut -d '_' -f 1)
    # Check if the sample names match
    if [[ ${SAMPLE1} != ${SAMPLE2} ]]; then
        echo "Sample names do not match for line ${i}: ${SAMPLE1} vs ${SAMPLE2}"
        exit 1
    fi
    # Concatenate the read files
    cat ${R1_1} ${R1_2} > ${OUTDIR}/${SAMPLE1}_R1_001.fastq.gz
    cat ${R2_1} ${R2_2} > ${OUTDIR}/${SAMPLE1}_R2_001.fastq.gz
    echo "Concatenated reads for sample ${SAMPLE1} into ${OUTDIR}/${SAMPLE1}_R1_001.fastq.gz and ${OUTDIR}/${SAMPLE1}_R2_001.fastq.gz"
done

# Now create a new samplesheet with the concatenated reads
# Use the samplesheet.sh script to create the samplesheet
bash /nemo/stp/babs/working/bootj/github/utilities/samplesheet.sh -d ${OUTDIR} -o ${OUTDIR}/samplesheet_concat.csv

# Check if the samplesheet was created successfully
if [[ ! -f ${OUTDIR}/samplesheet_concat.csv ]]; then
    echo "Failed to create the samplesheet."
    exit 1
fi

# Notify user of completion
echo "Concatenation completed. Merged reads are located in ${OUTDIR} and samplesheet is ${OUTDIR}/samplesheet_concat.csv."
exit 0