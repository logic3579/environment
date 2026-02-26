#!/bin/bash

### SCRIPT: trash.sh
###
### DESCRIPTION:
###   Move files to macOS Trash (~/.Trash) instead of permanently deleting them.
###   On Linux, moves files to XDG trash (~/.local/share/Trash).
###
### USAGE:
###   ./trash.sh [-h] <file1> [file2] ...
###
### EXAMPLES:
###   ./trash.sh foo.txt
###   ./trash.sh dir1 file2.log

set -euo pipefail

function show_help() {
  perl -ne 'print if s/^### ?//' "$0" || \
  sed -rn 's/^### ?//;T;p;' "$0"
  exit 0
}

if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
fi

OS="$(uname -s)"

for item in "$@"; do
  if [[ ! -e "$item" && ! -L "$item" ]]; then
    echo "[WARNING] '$item' does not exist, skipping." >&2
    continue
  fi

  basename="$(basename "$item")"
  timestamp="$(date +%Y%m%d%H%M%S)"

  case "$OS" in
    Darwin)
      TRASH_DIR="$HOME/.Trash"
      ;;
    Linux)
      TRASH_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/Trash/files"
      mkdir -p "$TRASH_DIR"
      ;;
    *)
      echo "[ERROR] Unsupported OS: $OS" >&2
      exit 1
      ;;
  esac

  # Append timestamp to avoid name collisions
  dest="$TRASH_DIR/$basename"
  if [[ -e "$dest" ]]; then
    dest="$TRASH_DIR/${basename}.${timestamp}"
  fi

  mv "$item" "$dest"
  echo "[INFO] Moved '$item' -> '$dest'"
done
