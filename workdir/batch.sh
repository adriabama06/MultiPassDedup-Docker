#!/usr/bin/env bash

# Exit on error
set -e

WORKDIR="./workdir"
OUTDIR="$WORKDIR/out"

# Create output directory if it doesn't exist
mkdir -p "$OUTDIR"

# Enable nullglob so unmatched globs don't return literal patterns
shopt -s nullglob

for INPUT in "$WORKDIR"/*.mp4 "$WORKDIR"/*.mov "$WORKDIR"/*.mkv; do
    FILENAME=$(basename "$INPUT")
    NAME="${FILENAME%.*}"
    OUTPUT="$OUTDIR/$NAME.mkv"

    echo "Processing: $INPUT"
    python infer.py \
        -i "$INPUT" \
        -o "$OUTPUT" \
        -np 4 \
        -t 4 \
        -m rife \
        -s \
        -st 0.3 \
        -scale 1.0
done

echo "All files processed."
