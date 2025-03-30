#!/bin/bash

CWD=$(dirname "$(realpath "$0")")

# Check if stow is installed
if ! command -v stow &> /dev/null; then
  echo "stow could not be found. Please install it first."
  exit 1
fi

# Read every directory in the current folder
for dir in "$CWD"/*/; do
  # Remove the trailing slash from the directory name
  dir=${dir%/}
  
  # Check if the directory is not empty
  echo "Stowing $dir..."
  stow "$dir"
done

echo
echo "All directories have been stowed."
