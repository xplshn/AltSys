#!/bin/sh
# vim: set ts=4 sw=4 et:

# Check for VIRTUALIZATION environment variable
[ -n "$VIRTUALIZATION" ] && return 0

msg "Initializing swap..."

# List all swap devices in /etc/fstab and activate them one by one using Toybox swapon
grep -E '^\S+\s+swap\s+' /etc/fstab | while read -r device _; do
    toybox swapon "$device" || emergency_shell
done