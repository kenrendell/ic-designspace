#!/bin/sh
# Usage: append-envv.sh <env-variable> <path>
# Append path to environment variable

[ "$#" -ne 2 ] && \
	{ printf 'Usage: append-envv.sh <env-variable> <path>\n'; exit 1; }

{ [ -n "$2" ] && [ "$2" = "${2#*:}" ]; } || \
	{ printf "No ':' character is allowed!\n"; exit 1; }

envv="$(printenv "$1")" || { printf "No environment variable %s exists!\n" "$1"; exit 1; }

case ":${envv}:" in
	(*":${2}:"*) # delete entry if exists
		lpath="${envv%:"${2}"*}"; [ "$lpath" = "${envv}" ] && lpath=
		rpath="${envv#*"${2}":}"; [ "$rpath" = "${envv}" ] && rpath=

		{ [ -n "$lpath" ] && envv="${lpath}:"; } || envv=
		[ -n "$rpath" ] && envv="${envv}${rpath}:"

		envv="${envv}${2}";;
	(*) envv="${envv}:${2}";;
esac;

printf '%s\n' "${envv}"
