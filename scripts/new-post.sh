#!/usr/bin/env bash

set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo 'Usage: ./scripts/new-post.sh "Post Title"'
  exit 1
fi

title="$*"

slug_source="$(printf '%s' "$title" | iconv -t ascii//TRANSLIT 2>/dev/null || printf '%s' "$title")"
slug="$(printf '%s' "$slug_source" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')"

if [[ -z "$slug" ]]; then
  echo 'Could not derive a valid slug from the provided title.'
  exit 1
fi

target_dir="content/posts/$slug"
target_file="$target_dir/index.md"

if [[ -e "$target_file" ]]; then
  echo "Post already exists: $target_file"
  exit 1
fi

mkdir -p "$target_dir"

timestamp="$(date --iso-8601=seconds)"
escaped_title="${title//\"/\\\"}"

cat > "$target_file" <<EOF
+++
title = "$escaped_title"
date = '$timestamp'
draft = true
tags = []
summary = ""
description = ""
toc = true
+++

## TL;DR

## Context

## What I Did

## Key Findings

## References
EOF

printf 'Created %s\n' "$target_file"
printf 'Drop related images next to the post inside %s\n' "$target_dir"
printf 'Preview with: hugo server -D\n'