#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p rustup bash
#! nix-shell -I nixpkgs=channel:nixpkgs-unstable

# Usage: install-openvaf.sh <override-LLVM-install>

LLVM_TAG='llvmorg-15.0.7' # see https://github.com/llvm/llvm-project/tags
LLVM_PROJECTS='llvm;clang;lld' # see https://llvm.org/docs/GettingStarted.html#getting-the-source-code-and-building-llvm

cd "${0%/*}/.." || exit 1

command mkdir -p tmp || exit 1

REPO_DIR="$(pwd)/tmp/OpenVAF" || exit 1
LLVM_ENV="${REPO_DIR%/*}/llvm.env"

# Build LLVM and Clang
./scripts/install-llvm.sh "${LLVM_TAG}" "${LLVM_PROJECTS}" "${1}" || exit 1
{ [ -f "${LLVM_ENV}" ] && . "${LLVM_ENV}"; } || exit 1

{ command rm -rf "${REPO_DIR}" && \
git clone https://github.com/arpadbuermen/OpenVAF "${REPO_DIR}"; } || exit 1

# Build OpenVAF
{ cd "${REPO_DIR}" && cargo build --release --bin openvaf-r; } || exit 1

# Test
#RUN_SLOW_TESTS=1 cargo test --release
#./target/release/openvaf-r --version
