#!/usr/bin/env bash
set -e
source "$(dirname "$0")/telegram_common.sh"

duration_min=$(( BUILD_DURATION / 60 ))
duration_sec=$(( BUILD_DURATION % 60 ))

ZIP_ESC=$(esc "${ZIP_NAME}.zip")
BRANCH_ESC=$(esc "${KERNEL_BRANCH}")
COMMIT_MSG_ESC=$(esc "${KERNEL_COMMIT_MSG}")
COMMIT_URL_ESC=$(esc_url "${KERNEL_COMMIT_URL}")
TIME_ESC=$(esc "${duration_min}m ${duration_sec}s")
VARIANT_ESC=$(esc "${BUILD_VARIANT}")
KSU_ESC=$(esc "${KSU_VARIANT}")
RUN_URL_ESC=$(esc_url "${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}")

TOOLCHAIN_NAME="${CLANG_TOOLCHAIN:-Clang}"

if [ -n "${CLANG_PATH}" ] && [ -x "${CLANG_PATH}/clang" ]; then
  CLANG_VER_STR=$("${CLANG_PATH}/clang" --version | head -n 1 | sed -n 's/.*clang version \([0-9.]*\).*/\1/p')
  
  if [ -z "$CLANG_VER_STR" ]; then
    CLANG_VER_STR="unknown"
  fi
  
  CLANG_ESC=$(esc "${TOOLCHAIN_NAME} ${CLANG_VER_STR}")
else
  CLANG_ESC=$(esc "N/A")
fi

CAPTION_FILE=$(mktemp)

printf '✅ *Build Successful* ✅\n\n'                          >> "$CAPTION_FILE"
printf '%s\n\n'              "${ZIP_ESC}"                     >> "$CAPTION_FILE"
printf '*Branch:* %s\n'      "${BRANCH_ESC}"                  >> "$CAPTION_FILE"
printf '*Commit:* [%s](%s)\n' "${COMMIT_MSG_ESC}" "${COMMIT_URL_ESC}" >> "$CAPTION_FILE"
printf '*Time:* %s\n'        "${TIME_ESC}"                    >> "$CAPTION_FILE"
printf '*Build Variant:* %s\n' "${VARIANT_ESC}"               >> "$CAPTION_FILE"
printf '*KernelSU:* %s\n'    "${KSU_ESC}"                     >> "$CAPTION_FILE"
printf '*Clang:* %s\n'       "${CLANG_ESC}"                   >> "$CAPTION_FILE"

if [ "${KSU_VARIANT}" != "Stock" ]; then
  printf '*Manager:* [Download](%s)\n' "$(esc_url "${KSU_REPO}/releases/latest")" >> "$CAPTION_FILE"
fi

if [ -n "${CUSTOM_NOTE}" ]; then
  printf '\n*Note:* %s\n' "$(esc "${CUSTOM_NOTE}")"           >> "$CAPTION_FILE"
fi

printf '\n[View Run](%s)\n' "${RUN_URL_ESC}"                  >> "$CAPTION_FILE"

curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendDocument" \
  -F chat_id="${TELEGRAM_CHAT_ID}" \
  -F parse_mode="MarkdownV2" \
  -F "caption=<${CAPTION_FILE}" \
  -F "document=@${ANYKERNEL_DIR}/${ZIP_NAME}.zip"

rm -f "$CAPTION_FILE"
