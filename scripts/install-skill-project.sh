#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root/plan-review"
target_dir="$repo_root/.codex/skills/plan-review"

if [[ ! -d "$source_dir" ]]; then
  echo "Skill source directory not found: $source_dir" >&2
  exit 1
fi

mkdir -p "$target_dir"
cp -R "$source_dir"/. "$target_dir"/

echo "Installed plan-review into project-local Codex folder at $target_dir"
