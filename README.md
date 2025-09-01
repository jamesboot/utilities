# Overview

This repo contains utility scripts for a variety of functions that might be helpful here and there.

## concat_vcf.py

### Usage
Script can be used in the following way from the command line:

```
python vcfConcat.py indir pattern
```

- indir : path, in quotes, to input directory containing VCF files for concatenation, must end with trailing /
- pattern : regex pattern, in quotes, of the VCF files for concantenation

```
python vcfConcat.py "/nemo/lab/bauerd/home/users/pateld1/250207_DP_BULK_vgp1/results/09_variants/clair3/" "*.clair3.full_alignment.vcf"
```

### Output
The script will save to the working directory a CSV file called All_Samples_VCF.csv
