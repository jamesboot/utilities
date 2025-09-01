import pandas as pd
import io
import os
import glob
import sys

# Define function to read in vcf
def read_vcf(path):
    with open(path, 'r') as f:
        lines = [l for l in f if not l.startswith('##')]
    return pd.read_csv(
        io.StringIO(''.join(lines)),
        dtype={'#CHROM': str, 'POS': int, 'ID': str, 'REF': str, 'ALT': str,
               'QUAL': str, 'FILTER': str, 'INFO': str},
        sep='\t'
    ).rename(columns={'#CHROM': 'CHROM'})
    
# Define function for concatenating vcf files 
def concat_vcf(indir, pattern):
    # Locate files
    fileList = glob.glob(indir + pattern)
    # For loop to loop through file list, load, edit, add to list 
    DFlist = list()
    for file in fileList:
        # Get samoke name from file name
        sample = os.path.basename(file).split('.')[0]
        # Read in vcf using custom function
        vcfDF = read_vcf(file)
        # Split the genotype column for each row
        vcfDF[['GT', 'GQ', 'DP', 'AD', 'AF']] = vcfDF[sample].str.split(':', expand = True)
        # Drop un-needed rows
        vcfDF = vcfDF.drop(columns = [sample, 'FORMAT'])
        # Add new sample column
        vcfDF['SAMPLE'] = sample
        # Append to list 
        DFlist.append(vcfDF)
    # Concat the dataframes
    df = pd.concat(DFlist).reset_index(drop = True)
    # Save dataframe as CSV 
    df.to_csv('All_Samples_VCF.csv')

# Usage 
if __name__ == "__main__":
    concat_vcf(indir = sys.argv[1], pattern = sys.argv[2])
