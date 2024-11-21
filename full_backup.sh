#!/bin/bash

# 0 17 * * * /path/to/backup.sh /path/to/directories.txt /path/to/backup_destination /path/to/backup.log


# Check if correct number of arguments is passed
if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <directories_file> <backup_destination> <log_file>"
  exit 1
fi

# Assign command-line arguments to variables
directories_file=$1
backup_destination=$2
log_file=$3

# Check if directories file exists
if [[ ! -f "$directories_file" ]]; then
  echo "Error: Directories file '$directories_file' not found!" >> "$log_file"
  exit 1
fi

# Make sure the backup destination exists
mkdir -p "$backup_destination"

# Log start time
echo "Backup started at $(date)" >> "$log_file"

# Loop through each directory listed in the directories file
while IFS= read -r directory; do
  if [[ -d "$directory" ]]; then
    # Get directory name to use in the backup filename
    dir_name=$(basename "$directory")
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup_file="${backup_destination}/${dir_name}_${timestamp}.zip"
    
    # Zip all files in the directory and send output to log file
    zip -r "$backup_file" "$directory" >> "$log_file" 2>&1
    echo "Backed up '$directory' to '$backup_file'" >> "$log_file"
  else
    echo "Warning: '$directory' does not exist or is not a directory" >> "$log_file"
  fi
done < "$directories_file"

# Log completion time
echo "Backup completed at $(date)" >> "$log_file"

