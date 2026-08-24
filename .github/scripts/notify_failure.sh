#!/usr/bin/env bash
set -e
source "$(dirname "$0")/telegram_common.sh"

BRANCH=$(esc "${KERNEL_BRANCH:-${INPUT_KERNEL_BRANCH}}")
RUN_URL_ESC=$(esc_url "${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}")

if [ -n "${BUILD_VARIANT}" ]; then
  VARIANT_TAG="${BUILD_VARIANT}"
elif [ "${ENABLE_KSU}" == "true" ]; then
  if [ "${ENABLE_SUSFS}" == "true" ] && [ "${KSU_VARIANT_INPUT}" != "xxKSU" ]; then
    VARIANT_TAG="KernelSU + SUSFS"
  else
    VARIANT_TAG="KernelSU"
  fi
else
  VARIANT_TAG="Normal"
fi

MSG_FILE=$(mktemp)

printf '❌ *Build Failed* ❌\n\n'                 >> "$MSG_FILE"
printf '*Branch:* %s\n'        "${BRANCH}"       >> "$MSG_FILE"

if [ -n "${KERNEL_COMMIT_MSG}" ]; then
  if [ -n "${KERNEL_COMMIT_URL}" ]; then
    printf '*Commit:* [%s](%s)\n' "$(esc "${KERNEL_COMMIT_MSG}")" "$(esc_url "${KERNEL_COMMIT_URL}")" >> "$MSG_FILE"
  else
    printf '*Commit:* %s\n' "$(esc "${KERNEL_COMMIT_MSG}")" >> "$MSG_FILE"
  fi
fi

printf '*Build Variant:* %s\n' "$(esc "${VARIANT_TAG}")" >> "$MSG_FILE"

if [ "${ENABLE_KSU}" == "true" ]; then
  printf '*KernelSU:* %s\n' "$(esc "${KSU_VARIANT_INPUT:-N/A}")" >> "$MSG_FILE"
fi

if [ -n "${CUSTOM_NOTE}" ]; then
  printf '\n*Note:* %s\n' "$(esc "${CUSTOM_NOTE}")" >> "$MSG_FILE"
fi

printf '\n[View Logs](%s)\n' "${RUN_URL_ESC}"    >> "$MSG_FILE"

curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  -d chat_id="${TELEGRAM_CHAT_ID}" \
  -d parse_mode="MarkdownV2" \
  -d disable_web_page_preview=true \
  --data-urlencode "text@${MSG_FILE}"

rm -f "$MSG_FILE"
