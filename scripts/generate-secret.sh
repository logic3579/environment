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

# Displays help information extracted from the header of this script.
show_help() {
  # Use perl or sed to extract lines starting with '### '
  perl -ne 'print if s/^### ?//' "$0" || \
  sed -rn 's/^### ?//;T;p;' "$0"
  exit 0
}

# Logging function for standardized output.
log_warning() {
  echo "[WARNING] $*" >&2
}

# Core logic to generate the password and hash, then print the results.
generate_and_print_secret() {
  local length=$1

  local password
  password=$(base64 < /dev/urandom | head -c "$length")

  local hash
  hash=$(echo -n "$password" | sha256sum | awk '{print $1}')

  # --- Output Results ---
  echo "-------------------------"
  echo "Generated Password: ${password}"
  echo "SHA256 Hash:        ${hash}"
  echo "-------------------------"
}

# Check for help request first
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
fi

# Parameter Processing and Validation
# Validate that the password length is a positive integer.
DEFAULT_LENGTH=13
PASSWORD_LENGTH=${1:-$DEFAULT_LENGTH}
if ! [[ "$PASSWORD_LENGTH" =~ ^[0-9]+$ ]]; then
    log_warning "Password length must be a positive integer."
    show_help
fi

# Execute the main function
generate_and_print_secret "$PASSWORD_LENGTH"

exit 0
