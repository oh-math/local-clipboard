#!/bin/bash

DIR="/home/[your_user]/simple_cache"

# Check if the directory exists
if [ ! -d "$DIR" ]; then
    echo "Directory does not exist"
    exit 1
fi


# Remove all files in the directory
rm -rf "$DIR"/*

# Verify the deletion
if [ $? -eq 0 ]; then
    echo "All files in $DIR have been deleted successfully."
else
    echo "An error occurred while trying to delete files."
fi