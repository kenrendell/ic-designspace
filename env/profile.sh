#!/bin/sh

# User specific environment and startup programs
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"

# Load functions
. "${ICD_DIR}/env/functions.sh"

PATH="$(prepend_envv PATH "${XDG_STATE_HOME}/nix/profile/bin")" || return 1
PATH="$(prepend_envv PATH "${HOME}/.local/bin")" || return 1
export PATH

# Additional XDG directory to search for data files.
XDG_DATA_DIRS="$(prepend_envv XDG_DATA_DIRS "${XDG_STATE_HOME}/nix/profile/share")" || return 1
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
