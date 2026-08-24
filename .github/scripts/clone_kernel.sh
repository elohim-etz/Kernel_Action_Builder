#!/usr/bin/env bash
set -e

KERNEL_REPO_INPUT="${INPUT_KERNEL_REPO}"
PRIVATE_TOKEN="${INPUT_PRIVATE_TOKEN}"

if [ -n "${PRIVATE_TOKEN}" ]; then
  AUTHED_URL=$(echo "${KERNEL_REPO_INPUT}" | sed "s|https://|https://oauth2:${PRIVATE_TOKEN}@|")
else
  AUTHED_URL="${KERNEL_REPO_INPUT}"
fi

git clone --depth=1 "${AUTHED_URL}" -b "${INPUT_KERNEL_BRANCH}" kernel
cd kernel

REPO_BASE=$(echo "${KERNEL_REPO_INPUT}" | sed 's|\.git$||')
FULL_COMMIT=$(git rev-parse HEAD)
if echo "${REPO_BASE}" | grep -q "gitlab"; then
  COMMIT_URL="${REPO_BASE}/-/commit/${FULL_COMMIT}"
else
  COMMIT_URL="${REPO_BASE}/commit/${FULL_COMMIT}"
fi

{
  echo "KERNEL_REPO=${KERNEL_REPO_INPUT}"
  echo "KERNEL_DIR=$(pwd)"
  echo "KERNEL_BRANCH=${INPUT_KERNEL_BRANCH}"
  echo "KERNEL_COMMIT=${FULL_COMMIT:0:8}"
  echo "KERNEL_COMMIT_URL=${COMMIT_URL}"
  echo "DEFCONFIG=${INPUT_DEFCONFIG}"
} >> "$GITHUB_ENV"

echo "KERNEL_VERSION=$(make kernelversion 2>/dev/null || echo 'unknown')" >> "$GITHUB_ENV"
echo "KERNEL_COMMIT_MSG=$(git log -1 --pretty=format:'%s')" >> "$GITHUB_ENV"
