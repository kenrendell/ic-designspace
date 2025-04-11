#!/bin/sh

# User specific environment and startup programs
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"

ICD_DIR="$(cd "${0%/*}/.." && pwd)" || return 1
export ICD_DIR

PATH="$("${ICD_DIR}/env/append-envv.sh" PATH "${HOME}/.local/bin")" || return 1 # must be appended first since we will use nixGL wrapper for nix programs
PATH="$("${ICD_DIR}/env/append-envv.sh" PATH "${XDG_STATE_HOME}/nix/profile/bin")" || return 1
export PATH

# Additional XDG directory to search for data files. 
XDG_DATA_DIRS="$("${ICD_DIR}/env/append-envv.sh" XDG_DATA_DIRS "${XDG_STATE_HOME}/nix/profile/share")" || return 1
export XDG_DATA_DIRS

# PDK environment
export PDK_ROOT="${XDG_DATA_HOME}/IHP-Open-PDK"
export PDK='ihp-sg13g2'
export KLAYOUT_PATH="${HOME}/.klayout:${PDK_ROOT}/${PDK}/libs.tech/klayout"
export KLAYOUT_HOME="${HOME}/.klayout"

# Nix Package Manager
export NIXPKGS_ALLOW_UNFREE=1
export NIXPKGS="${ICD_DIR}/nixpkgs"

# Load aliases
. "${ICD_DIR}/env/aliases.sh"
