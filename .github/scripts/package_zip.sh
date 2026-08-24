#!/usr/bin/env bash
set -e

rm -f AnyKernel/Image.gz
rm -f AnyKernel/*.zip
cp "${KERNEL_DIR}/out/arch/arm64/boot/Image.gz" AnyKernel/

cd AnyKernel
TIMESTAMP=$(date +"%Y%m%d-%H%M")

if [ "${KSU_VARIANT}" != "Stock" ]; then
  if [ "${SUSFS_ENABLED}" == "true" ]; then
    ZIP_NAME="Miku-RM6785-${KSU_VARIANT}-SUSFS-${TIMESTAMP}"
  else
    ZIP_NAME="Miku-RM6785-${KSU_VARIANT}-${TIMESTAMP}"
  fi
else
  ZIP_NAME="Miku-RM6785-Stock-${TIMESTAMP}"
fi

zip -r9 "${ZIP_NAME}.zip" . -x '*.git*' > /dev/null 2>&1

{
  echo "ZIP_NAME=${ZIP_NAME}"
  echo "ANYKERNEL_DIR=$(pwd)"
} >> "$GITHUB_ENV"
