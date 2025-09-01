# Script for copying files on NEMO using rysnc

#!/bin/bash

#SBATCH --job-name=move-file
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --partition=ncpu

# Set your source and destination paths
FILE="/path/to/source/file.txt"
DESINATION="/path/to/destination/"

# Load any required modules (optional, depends on your system)
# module load rsync

echo "Starting file copy with rsync..."
echo "Source: $FILE"
echo "Destination: $DESINATION"

# Run rsync
rsync -avh "$FILE" "$DESINATION"

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "File copied successfully."
else
    echo "File copy failed." >&2
    exit 1
fi
