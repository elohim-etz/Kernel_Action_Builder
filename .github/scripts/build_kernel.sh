#!/usr/bin/env bash
set -eo pipefail
cd "${KERNEL_DIR}"

start_time=$(date +%s)

export PATH="${GITHUB_WORKSPACE}/clang/bin:${PATH}"
export KBUILD_BUILD_USER="elohim-etz"
export KBUILD_BUILD_HOST="GitHub-Actions"

mkdir -p out

echo "=== Generating defconfig: ${DEFCONFIG} ===" | tee -a "$BUILD_LOG"
make O=out ARCH=${ARCH} ${DEFCONFIG} 2>&1 | tee -a "$BUILD_LOG"

echo "=== Starting kernel build ===" | tee -a "$BUILD_LOG"
make -j$(nproc --all) O=out \
                      ARCH=${ARCH} \
                      CC="ccache clang" \
                      LLVM=1 \
                      CONFIG_NO_ERROR_ON_MISMATCH=y \
                      2>&1 | tee -a "$BUILD_LOG"

grep -i -E "error:|undefined reference|fatal error" \
  "$BUILD_LOG" > "$ERROR_LOG" || true

BUILD_DURATION=$(( $(date +%s) - start_time ))
echo "BUILD_DURATION=${BUILD_DURATION}" >> "$GITHUB_ENV"

ccache --show-stats | tee -a "$BUILD_LOG"
