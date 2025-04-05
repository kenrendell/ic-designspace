#!/bin/sh

# User specific environment and startup programs
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"

# To execute user binaries without specifying the relative/absolute path
append_path () {
	if [ -n "$1" ] && [ "$1" = "${1#*:}" ]; then
		case ":${PATH}:" in
			(*":${1}:"*)
				lpath="${PATH%:${1}*}"; [ "$lpath" = "$PATH" ] && lpath=
				rpath="${PATH#*${1}:}"; [ "$rpath" = "$PATH" ] && rpath=

				{ [ -n "$lpath" ] && PATH="${lpath}:"; } || PATH=
				[ -n "$rpath" ] && PATH="${PATH}${rpath}:"

				PATH="${PATH}${1}";;
			(*) PATH="${PATH}:${1}";;
		esac;
	fi
}

append_path "${HOME}/.local/bin" # must be appended first since we are using nixGL wrapper for nix programs
append_path "${XDG_STATE_HOME}/nix/profile/bin"
export PATH

# Additional XDG directory to search for data files. 
append_data () { [ "$1" = "${1#*:}" ] && case ":${XDG_DATA_DIRS}:" in (*":${1}:"*);; (*) XDG_DATA_DIRS="${XDG_DATA_DIRS}:${1}";; esac; }
append_data "${XDG_STATE_HOME}/nix/profile/share"
export XDG_DATA_DIRS

# IHP PDK environment for Xschem
export PDK_ROOT="${XDG_DATA_HOME}/IHP-Open-PDK"
export PDK='ihp-sg13g2'

# Nix Package Manager
export NIXPKGS_ALLOW_UNFREE=1
