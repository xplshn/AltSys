#!/bin/sh

apply_patches() {
    PATCH_DIR="patches/busybox"
    BUSYBOX_DIR="busybox"

    # Change to the BusyBox directory
    cd "$BUSYBOX_DIR" || {
        echo "Failed to change to directory: $BUSYBOX_DIR"
        exit 1
    }

    for patch_file in "../$PATCH_DIR"/*.patch; do
        patch_name=$(basename "$patch_file")

        if ! patch -p1 --dry-run -i "$patch_file" >/dev/null 2>&1; then
            echo "Applying patch: $patch_name"
            patch -p1 -i "$patch_file" || {
                echo "Failed to apply patch: $patch_name"
                exit 1
            }
        else
            echo "Patch $patch_name is already applied. Rejecting."
            patch -p1 -R -i "$patch_file" || {
                echo "Failed to reject patch: $patch_name"
                exit 1
            }
        fi
    done

    echo "All patches applied successfully (if not already applied)."
}

# Execute the function
apply_patches
