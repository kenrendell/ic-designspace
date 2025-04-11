#!/bin/sh

# User specific environment and startup programs
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"

prepend_envv () {
	{ [ -n "$2" ] && [ "$2" = "${2#*:}" ]; } || { printf "No ':' character is allowed!\n"; return 1; }

	envv="$(printenv "$1")" || { printf "No environment variable %s exists!\n" "$1"; return 1; }

	case ":${envv}:" in
		(*":${2}:"*) # delete entry if exists
			lpath="${envv%:"${2}"*}"; [ "${lpath}" = "${envv}" ] && lpath=
			rpath="${envv#*"${2}":}"; [ "${rpath}" = "${envv}" ] && rpath=

			{ [ -n "${rpath}" ] && envv=":${rpath}"; } || envv=
			[ -n "${lpath}" ] && envv=":${lpath}${envv}"

			envv="${2}${envv}";;
		(*) envv="${2}:${envv}";;
	esac;

	printf '%s\n' "${envv}"
}

PATH="$(prepend_envv PATH "${XDG_STATE_HOME}/nix/profile/bin")" || return 1
PATH="$(prepend_envv PATH "${HOME}/.local/bin")" || return 1
export PATH

# Additional XDG directory to search for data files.
XDG_DATA_DIRS="$(append_envv XDG_DATA_DIRS "${XDG_STATE_HOME}/nix/profile/share")" || return 1
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
