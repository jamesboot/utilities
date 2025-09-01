# Script to find files starting with a certain name in a specified folder
# Outputs a .txt file with full paths to found files

# Define the path to the file containing the sample names
prefix_file=names1.txt

# Define the directory where you want to search for the files
# Give the full path
directory=/nemo/lab/bauerd/data/STPs/babs/inputs/harriet.mears/asf/amplicon_sequencing-DN19023/240530_M02212_0454_000000000-DNTJ3/fastq/

# While loop to loop through the prefix file
while IFS= read -r prefix; do
    if [ -n "$prefix" ]; then # Ensure the prefix is not empty
        echo "Searching for files starting with '$prefix':"
        find "$directory" -type f -name "${prefix}*" -print >> files.txt
    fi
done < "$prefix_file"