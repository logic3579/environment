#!/bin/bash

### SCRIPT: generate-secret.sh
###
### DESCRIPTION:
###   Generate a random password with its SHA256 hash, or a JWT HMAC secret.
###
### USAGE:
###   ./scripts/generate-secret.sh [password] [LENGTH] [--raw]
###   ./scripts/generate-secret.sh jwt [--algorithm HS256|HS384|HS512]
###                                  [--format base64url|hex] [--raw]
###
### OPTIONS:
###   LENGTH          Password characters, 1-4096 (default: 13).
###   --algorithm     JWT HMAC algorithm (default: HS256).
###                   Uses 32/48/64 random bytes for HS256/HS384/HS512.
###   --format        JWT secret encoding (default: base64url, without padding).
###   --raw           Print only the secret, followed by a newline.
###   -h, --help      Show this help.
###
### EXAMPLES:
###   ./scripts/generate-secret.sh
###   ./scripts/generate-secret.sh 32
###   ./scripts/generate-secret.sh password 32 --raw
###   ./scripts/generate-secret.sh jwt
###   ./scripts/generate-secret.sh jwt --algorithm HS512 --format hex
###   JWT_SECRET=$(./scripts/generate-secret.sh jwt --raw)
###
### NOTES:
###   JWT mode requires OpenSSL and generates a shared secret, not a JWT token
###   or an RSA/EC key pair. Use the output as your application's secret string;
###   decode it only if the library explicitly expects encoded key material.
###   Signing and verification must use the same representation.
###   The password SHA256 output is a checksum, not a password-storage hash.

set -euo pipefail

show_help() {
  sed -n 's/^### \{0,1\}//p' "$0"
}

fail() {
  printf 'Error: %s\nUse --help for usage.\n' "$1" >&2
  exit 1
}

mode=password
length=13
length_set=false
raw=false
algorithm=HS256
format=base64url

case "${1:-}" in
  password|jwt) mode=$1; shift ;;
esac

while (( $# > 0 )); do
  case "$1" in
    -h|--help) show_help; exit 0 ;;
    --raw) raw=true; shift ;;
    --algorithm|--format)
      [[ "$mode" == jwt ]] || fail "$1 is only available in jwt mode."
      (( $# >= 2 )) || fail "$1 requires a value."
      case "$1" in
        --algorithm) algorithm=$2 ;;
        --format) format=$2 ;;
      esac
      shift 2
      ;;
    *)
      [[ "$mode" == password && "$length_set" == false ]] || fail "Unexpected argument: $1"
      [[ "$1" =~ ^[1-9][0-9]*$ && ${#1} -le 4 ]] || fail "Password length must be an integer from 1 to 4096."
      (( $1 <= 4096 )) || fail "Password length must be an integer from 1 to 4096."
      length=$1
      length_set=true
      shift
      ;;
  esac
done

if [[ "$mode" == jwt ]]; then
  case "$algorithm" in
    HS256) bytes=32 ;;
    HS384) bytes=48 ;;
    HS512) bytes=64 ;;
    *) fail "Unsupported algorithm: $algorithm (use HS256, HS384, or HS512)." ;;
  esac
  case "$format" in
    base64url|hex) ;;
    *) fail "Unsupported format: $format (use base64url or hex)." ;;
  esac
  command -v openssl >/dev/null 2>&1 || fail "JWT mode requires openssl."
  if [[ "$format" == hex ]]; then
    secret=$(openssl rand -hex "$bytes")
  else
    secret=$(openssl rand -base64 "$bytes" | tr '+/' '-_' | tr -d '=\n\r')
  fi
else
  secret=''
  # Filter bounded chunks, then truncate in Bash: no early pipe closure/SIGPIPE.
  while (( ${#secret} < length )); do
    chunk=$(LC_ALL=C head -c 512 /dev/urandom | LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*_+=-')
    secret+=$chunk
  done
  secret=${secret:0:length}
fi

if [[ "$raw" == true ]]; then
  printf '%s\n' "$secret"
elif [[ "$mode" == jwt ]]; then
  printf 'JWT Secret (%s, %s): %s\n' "$algorithm" "$format" "$secret"
else
  if command -v shasum >/dev/null 2>&1; then
    hash=$(printf '%s' "$secret" | shasum -a 256 | awk '{print $1}')
  else
    hash=$(printf '%s' "$secret" | sha256sum | awk '{print $1}')
  fi
  printf '%s\n' '-------------------------'
  printf 'Generated Password: %s\nSHA256 Hash:        %s\n' "$secret" "$hash"
  printf '%s\n' '-------------------------'
fi
