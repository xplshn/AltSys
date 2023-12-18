#!/bin/ksh

# Define directories
toybox_dir="/opt/AltSys/toybox"
sbase_dir="/opt/AltSys/obase/sbase"
ubase_dir="/opt/AltSys/obase/ubase"

# Function to remove duplicate files
remove_duplicate() {
    local src_dir="$1"
    local dest_dir="$2"

    for file in "$src_dir"/*; do
        file_name=$(basename "$file")
        if [ -f "$dest_dir"/bin/"$file_name" ]; then
            printf "Removing %s from %s...\n" "$file_name" "$src_dir"
            rm "$file"
        fi
    done
}

# Remove duplicates from toybox and ubase
remove_duplicate "$toybox_dir"/bin "$sbase_dir"
remove_duplicate "$toybox_dir"/usr/bin "$sbase_dir"
remove_duplicate "$toybox_dir"/usr/sbin "$sbase_dir"

remove_duplicate "$toybox_dir"/bin "$ubase_dir"
remove_duplicate "$toybox_dir"/usr/bin "$ubase_dir"
remove_duplicate "$toybox_dir"/usr/sbin "$ubase_dir"

# Remove duplicate man pages in toybox's share directory if it exists
if [ -d "$toybox_dir"/share/man ]; then
    find "$toybox_dir"/share/man -type f -exec sh -c 'file=$(basename "$1"); if [ -f "$ubase_dir/share/man/$file" ]; then rm "$1"; fi' _ {} \;
fi
