#!/bin/bash 

# Script for subsampling fastq files down to 1 million reads
# Script should be run in the folder containing the target fastq files

##### Set queue options
#$ -m bes
#$ -cwd
#$ -V
#$ -pe smp 2
#$ -l h_vmem=4G
#$ -l h_rt=240:0:0
#$ -N fastq-1M-subsample
#$ -j y
#####

# Sub sample 1M lines (250k reads) from each fastq and rename with 1M-prefix
for file in $(find . -type f -name '*.fastq.gz' -print);
  do gzip -cd ${file} | head -4000000 > "./1M-$(basename $file)";
done

# Make new directory for modified files
mkdir 1M_SubSample

# Move modified files to new directory
mv 1M*.fastq.gz 1M_SubSample/