#!/bin/bash
set -e

WEIGHTS_DIR="/MultiPassDedup/weights"
WEIGHTS_CHECK_FILE="${WEIGHTS_DIR}/rife48.pkl"
DOWNLOAD_URL="https://github.com/adriabama06/MultiPassDedup-Docker/releases/download/v0.0.1/MultiPassDedupWeights.zip"
ZIP_FILE="/tmp/MultiPassDedupWeights.zip"

if [ ! -d "$WEIGHTS_DIR" ] || [ ! -f "$WEIGHTS_CHECK_FILE" ]; then
    echo "Weights not found. Downloading..."
    wget -O "$ZIP_FILE" "$DOWNLOAD_URL"
    echo "Extracting weights..."
    unzip -o "$ZIP_FILE" -d /MultiPassDedup
    rm -f "$ZIP_FILE"
    echo "Weights downloaded and extracted successfully."
else
    echo "Weights already present. Skipping download."
fi

echo "Starting bash shell..."
exec /bin/bash
