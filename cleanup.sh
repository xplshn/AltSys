#!/bin/ksh

# Define directories
toybox_dir="/opt/AltSys/toybox"
sbase_dir="/opt/AltSys/obase/sbase"

# Compare files and remove duplicates
for file in "$toybox_dir"/bin/*; do
    file_name=$(basename "$file")
    if [ -f "$sbase_dir"/bin/"$file_name" ]; then
        printf "Removing %s from toybox...\n" "$file_name"
        rm "$file"
    fi
done

for file in "$toybox_dir"/usr/bin/*; do
    file_name=$(basename "$file")
    if [ -f "$sbase_dir"/bin/"$file_name" ]; then
        printf "Removing %s from toybox...\n" "$file_name"
        rm "$file"
    fi
done

for file in "$toybox_dir"/usr/sbin/*; do
    file_name=$(basename "$file")
    if [ -f "$sbase_dir"/bin/"$file_name" ]; then
        printf "Removing %s from toybox...\n" "$file_name"
        rm "$file"
    fi
done
