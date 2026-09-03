#!/usr/bin/env bash
set -euo pipefail

TOOLCHAIN="${INPUT_CLANG_TOOLCHAIN:-AOSP}"

case "${TOOLCHAIN}" in
  AOSP)
    echo "=== Using AOSP Clang ==="

    CLANG_PATH="${GITHUB_WORKSPACE}/clang/bin"

    if [ ! -x "${CLANG_PATH}/clang" ]; then
      echo "ERROR: AOSP Clang not found at ${CLANG_PATH}"
      exit 1
    fi
    ;;

  Neutron)
    echo "=== Installing Neutron Clang ==="

    NEUTRON_DIR="${HOME}/toolchains/neutron-clang"
    mkdir -p "${NEUTRON_DIR}"
    cd "${NEUTRON_DIR}"

    if [ ! -x "${NEUTRON_DIR}/antman" ]; then
      curl -LO \
        "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman"
      chmod +x antman
    fi

    ./antman -S

    CLANG_PATH="${NEUTRON_DIR}/bin"

    if [ ! -x "${CLANG_PATH}/clang" ]; then
      echo "ERROR: Neutron Clang not found at ${CLANG_PATH}"
      exit 1
    fi
    ;;

  *)
    echo "ERROR: Unknown Clang toolchain: ${TOOLCHAIN}"
    exit 1
    ;;
esac

echo "Selected toolchain: ${TOOLCHAIN}"
echo "Clang path: ${CLANG_PATH}"

echo "CLANG_TOOLCHAIN=${TOOLCHAIN}" >> "${GITHUB_ENV}"
echo "CLANG_PATH=${CLANG_PATH}" >> "${GITHUB_ENV}"
echo "${CLANG_PATH}" >> "${GITHUB_PATH}"

"${CLANG_PATH}/clang" --version
