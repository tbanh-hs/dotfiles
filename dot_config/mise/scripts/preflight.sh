#!/bin/sh
set -eu
if ! command -v brew >/dev/null 2>&1; then
  printf '%s\n' 'Install Homebrew and run its shellenv command before bootstrapping.' >&2
  exit 1
fi
case "$(uname -s)" in
  Darwin)
    if [ "$(uname -m)" != arm64 ]; then
      printf '%s\n' 'This config needs Apple Silicon: mise bootstrap brew formulae do not support Intel Macs.' >&2
      exit 1
    fi
    ;;
  Linux)
    if ! command -v pacman >/dev/null 2>&1; then
      printf '%s\n' 'The Linux packages require Arch-based Linux with pacman.' >&2
      exit 1
    fi
    if ! command -v yay >/dev/null 2>&1 && ! command -v paru >/dev/null 2>&1; then
      printf '%s\n' 'Install yay or paru and base-devel before bootstrapping AUR packages.' >&2
      exit 1
    fi
    ;;
  *)
    printf '%s\n' 'This config targets macOS and Arch-based Linux.' >&2
    exit 1
    ;;
esac
