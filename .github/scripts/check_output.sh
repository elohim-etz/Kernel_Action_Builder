#!/usr/bin/env bash
set -e
cd "${KERNEL_DIR}"

if [ ! -f "out/arch/arm64/boot/Image.gz" ]; then
  echo "Image.gz not found — build failed."
  exit 1
fi

IMAGE_SIZE_MB=$(echo "scale=2; $(stat -c%s out/arch/arm64/boot/Image.gz) / 1048576" | bc)
echo "IMAGE_SIZE_MB=${IMAGE_SIZE_MB}" >> "$GITHUB_ENV"
echo "Image.gz OK (${IMAGE_SIZE_MB} MB)"
