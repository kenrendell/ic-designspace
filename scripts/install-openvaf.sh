#!/usr/bin/env nix
#! nix shell github:NixOS/nixpkgs/nixpkgs-unstable#llvmPackages_18.libllvm github:NixOS/nixpkgs/nixpkgs-unstable#llvmPackages_18.clangUseLLVM github:NixOS/nixpkgs/nixpkgs-unstable#rustup github:NixOS/nixpkgs/nixpkgs-unstable#bash --command bash
#
# Build dependencies (github:NixOS/nixpkgs/nixpkgs-unstable):
# - llvmPackages_18.libllvm
# - llvmPackages_18.clangUseLLVM
# - rustup

cd "${0%/*}/.." || exit 1

command mkdir -p ./.tmp || exit 1

REPO_DIR='./.tmp/OpenVAF'

{ command rm -rf "${REPO_DIR}" && \
git clone https://github.com/arpadbuermen/OpenVAF "${REPO_DIR}"; } || exit 1

echo "${LLVM_CONFIG}"
echo yeah

# Build OpenVAF
cd "${REPO_DIR}" && LLVM_CONFIG="$(which llvm-config)" cargo build --release --bin openvaf
