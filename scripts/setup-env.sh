#!/bin/sh

ICD_DIR="$(cd "${0%/*}/.." && pwd)" || exit 1

case "${SHELL}" in
	*bash) RC="${HOME}/.bashrc" ;;
	*zsh) RC="${ZDOTDIR:-"${HOME}"}/.zshrc" ;;
	*) printf 'Unsupported shell!\n'; exit 1 ;;
esac

cat << EOF >> "${RC}"

export ICD_DIR='${ICD_DIR}'
. "\${ICD_DIR}/env/profile.sh"
EOF

cat "${RC}"
