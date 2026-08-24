#!/usr/bin/env bash

# Escape plain text for MarkdownV2
esc() { printf '%s' "$1" | sed 's/[]\_*[()~`>#+=|{}.!-]/\\&/g'; }

# Escape a URL used inside a MarkdownV2 inline link
esc_url() { printf '%s' "$1" | sed 's/[\\()]/\\&/g'; }
