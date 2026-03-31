#!/bin/bash

### SCRIPT: generate_secret.sh
###
### DESCRIPTION:
###   Generates a random password of a specified length along with its SHA256 hash.
###
### USAGE:
###   ./generate_secret.sh -h
###   ./generate_secret.sh [PASSWORD_LENGTH]
###
### EXAMPLES:
###   ./generate_secret.sh         # Generate a default 13-character password
###   ./generate_secret.sh 32      # Generate a 32-character password

set -euo pipefail

show_help() {
  perl -ne 'print if s/^### ?//' "$0" || \
  sed -rn 's/^### ?//;T;p;' "$0"
  exit 0
}

generate_and_print_secret() {
  local length=$1

  local password
  password=$(head -c 512 /dev/urandom | LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*_+-=' | head -c "$length")

  local hash
  if command -v shasum >/dev/null 2>&1; then
    hash=$(printf '%s' "$password" | shasum -a 256 | awk '{print $1}')
  else
    hash=$(printf '%s' "$password" | sha256sum | awk '{print $1}')
  fi

  echo "-------------------------"
  echo "Generated Password: ${password}"
  echo "SHA256 Hash:        ${hash}"
  echo "-------------------------"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
fi

PASSWORD_LENGTH=${1:-13}
if ! [[ "$PASSWORD_LENGTH" =~ ^[1-9][0-9]*$ ]]; then
  echo "[WARNING] Password length must be a positive integer." >&2
  show_help
fi

generate_and_print_secret "$PASSWORD_LENGTH"
