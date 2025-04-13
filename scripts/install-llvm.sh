#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p cmake ninja bash
#! nix-shell -I nixpkgs=channel:nixpkgs-unstable

# Usage: install-llvm.sh <LLVM-tag> <LLVM-projects>

cd "${0%/*}/.." || exit 1

command mkdir -p tmp || exit 1

REPO_DIR="$(pwd)/tmp/llvm-project" || exit 1
INSTALL_DIR="${REPO_DIR}/LLVM"

{ command rm -rf "${REPO_DIR}" && \
git clone https://github.com/llvm/llvm-project.git "${REPO_DIR}" && git checkout "${1}"; } || exit 1

# Build LLVM
{ cd "${REPO_DIR}" && cmake -G Ninja -S llvm -B build -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' -DLLVM_ENABLE_PROJECTS="${2}"; } || exit 1
{ ninja -C build && ninja -C build install; } || exit 1

# To be evaluated by other scripts
printf "export LLVM_CONFIG='%s/bin/llvm-config'\n" "${INSTALL_DIR}"
printf "export PATH='%s/bin:%s'\n" "${INSTALL_DIR}" "${PATH}"
