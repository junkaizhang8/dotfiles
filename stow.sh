#!/usr/bin/env bash

set -euo pipefail

CWD="$(dirname "$(realpath "$0")")"
IGNORE_FILE="$CWD/.stow-ignore"

dry_run=0
flags=()

ignore_list=()

usage() {
  cat <<EOF
Usage: $0 [-h|--help] [-n|--dry-run] [-v|--verbose]

Options:
  -h, --help      Show this help message
  -n, --dry-run   Perform a dry run (no filesystem changes)
  -v, --verbose   Show detailed stow output
EOF
  exit 1
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      usage
      ;;
    -n | --dry-run)
      flags+=(-n)
      dry_run=1
      ;;
    -v | --verbose)
      flags+=(-v2)
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
    esac
    shift
  done
}

# Populate the ignore list from the .stow-ignore file
populate_ignore_list() {
  if [[ -f "$IGNORE_FILE" ]]; then
    while IFS= read -r line; do
      # Skip empty lines and comments
      [[ -z "$line" || "$line" =~ ^# ]] && continue
      # Store the directory name without trailing slash
      ignore_list+=("${line%/}")
    done <"$IGNORE_FILE"
  fi
}

# Helper function to check if a package should be ignored
should_ignore() {
  local dir="$1"
  for ignore in "${ignore_list[@]}"; do
    [[ "$dir" == "$ignore" ]] && return 0
  done
  return 1
}

main() {
  local packages=()

  command -v stow >/dev/null || {
    echo "Error: GNU stow is not installed."
    exit 1
  }

  parse_args "$@"

  populate_ignore_list

  readarray -t packages < <(find "$CWD" -mindepth 1 -maxdepth 1 -type d ! -name ".*" -exec basename {} \;)
  echo "Found ${#packages[@]} package(s)."

  for pkg in "${packages[@]}"; do
    should_ignore "$pkg" && continue

    printf "\n→ Stowing ${pkg}\n"

    if ! stow "${flags[@]}" "$pkg"; then
      echo "⚠ Failed to stow $pkg"
    fi
  done

  echo

  if [[ "$dry_run" -eq 1 ]]; then
    echo "Dry run complete. No changes were made."
  else
    echo "All packages processed."
  fi
}

main "$@"
