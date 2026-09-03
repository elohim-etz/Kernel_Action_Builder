#!/usr/bin/env bash
set -e
cd "${KERNEL_DIR}"

# ── Stock fallback ──────────────────────────────────────────────────────────
if [ "${ENABLE_KSU}" != "true" ]; then
  {
    echo "KSU_VARIANT=Stock"
    echo "SUSFS_ENABLED=false"
    echo "BUILD_VARIANT=Normal"
  } >> "$GITHUB_ENV"
  exit 0
fi

# ── Variants ────────────────────────────────────────────────────────────────
case "${KSU_VARIANT_INPUT}" in
  xxKSU)
    curl -LSs "https://raw.githubusercontent.com/backslashxx/KernelSU/master/kernel/setup.sh" | bash -s master
    KSU_BRANCH="master"; SUSFS="false"
    KSU_REPO="https://github.com/backslashxx/KernelSU"
    if [ "${ENABLE_SUSFS}" == "true" ]; then
      echo "::warning::xxKSU does not support SUSFS — flag ignored."
    fi
    ;;
  SukiSU)
    if [ "${ENABLE_SUSFS}" == "true" ]; then
      curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" | bash -s main
      KSU_BRANCH="main"; SUSFS="true"
    else
      curl -LSs "https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh" | bash -s builtin
      KSU_BRANCH="builtin"; SUSFS="false"
    fi
    KSU_REPO="https://github.com/SukiSU-Ultra/SukiSU-Ultra"
    ;;
  ReSukiSU)
    curl -LSs "https://raw.githubusercontent.com/ReSukiSU/ReSukiSU/main/kernel/setup.sh" | bash -s main
    KSU_BRANCH="main"
    KSU_REPO="https://github.com/ReSukiSU/ReSukiSU"
    SUSFS="${ENABLE_SUSFS}"
    ;;
esac

if [ "${SUSFS}" == "true" ]; then
  BUILD_VARIANT="KernelSU + SUSFS"
else
  BUILD_VARIANT="KernelSU"
fi

{
  echo "KSU_VARIANT=${KSU_VARIANT_INPUT}"
  echo "KSU_BRANCH=${KSU_BRANCH}"
  echo "KSU_REPO=${KSU_REPO}"
  echo "SUSFS_ENABLED=${SUSFS}"
  echo "BUILD_VARIANT=${BUILD_VARIANT}"
} >> "$GITHUB_ENV"
