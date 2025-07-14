#!/bin/bash

CWD=$(dirname "$(realpath "$0")")
IGNORE_FILE="$CWD/.stow-ignore"

dry_run=0

function usage() {
  echo "Usage: $0 [-n|--dry-run]"
  echo "Options:"
  echo "  -n, --dry-run   Perform a dry run without modifying your file system"
  exit 1
}

for arg in "$@"; do
  case $arg in
  -n | --dry-run)
    dry_run=1
    ;;
  *)
    echo "Unknown option: $arg"
    usage
    ;;
  esac
done

# Check if stow is installed
if ! command -v stow &>/dev/null; then
  echo "stow could not be found. Please install it first."
  exit 1
fi

IGNORE_LIST=()

# Read ignore file into array
if [[ -f "$IGNORE_FILE" ]]; then
  while IFS= read -r line; do
    # Skip empty lines and comments
    if [[ -n "$line" && ! "$line" =~ ^# ]]; then
      # Remove the trailing slash if it exists
      line="${line%/}"
      IGNORE_LIST+=("$line")
    fi
  done <"$IGNORE_FILE"
fi

# Check if a directory should be ignored
function should_ignore() {
  local dir_name="$1"
  for ignore in "${IGNORE_LIST[@]}"; do
    if [[ "$dir_name" == "$ignore" ]]; then
      return 0 # Ignore this directory
    fi
  done
  return 1 # Do not ignore this directory
}

# Read every directory in the current folder
for dir in "$CWD"/*/ "$CWD"/.*/; do
  # Remove the trailing slash from the directory name
  dir="${dir%/}"
  # Directory name without the path
  base_dir="$(basename "$dir")"

  # Skip if not a directory
  [[ -d "$dir" ]] || continue

  # Skip "." and ".."
  [[ "$base_dir" == "." || "$base_dir" == ".." ]] && continue

  # Skip if in ignore list
  should_ignore "$base_dir" && continue

  # Check if the directory is not empty
  echo "Stowing $base_dir..."
  if [[ "$dry_run" -eq 0 ]]; then
    stow "$base_dir"
  fi
done

echo
if [[ "$dry_run" -eq 1 ]]; then
  echo "Dry run complete. No directories were actually stowed."
else
  echo "All applicable directories have been stowed."
fi
