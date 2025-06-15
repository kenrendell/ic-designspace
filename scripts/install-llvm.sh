#!/bin/sh
# Usage: install-llvm.sh <LLVM-tag> <LLVM-projects> <override-install>
# For software requirements, see https://llvm.org/docs/GettingStarted.html#software

# NOTE: use `patchelf`
# See https://github.com/NixOS/patchelf

cd "${0%/*}/.." || exit 1

REPO_DIR="$(pwd)/tmp/llvm-project" || exit 1
INSTALL_DIR="${REPO_DIR}/LLVM"
LLVM_CONFIG="${INSTALL_DIR}/bin/llvm-config"
LLVM_ENV="${REPO_DIR%/*}/llvm.env"

command mkdir -p "${REPO_DIR%/*}" || exit 1

if [ -n "${3}" ] || ! { [ -f "${LLVM_CONFIG}" ] && [ -x "${LLVM_CONFIG}" ]; }; then
	{ command rm -rf "${REPO_DIR}" && \
	git clone --depth 1 --branch "${1}" --single-branch https://github.com/llvm/llvm-project.git "${REPO_DIR}"; } || exit 1

	# See https://llvm.org/docs/CMake.html
	{ cd "${REPO_DIR}" && cmake -G Ninja -S llvm -B build -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" -DCMAKE_BUILD_TYPE=Release \
		-DLLVM_ENABLE_ZLIB=FORCE_ON -DLLVM_ENABLE_ZSTD=FORCE_ON -DLLVM_TARGETS_TO_BUILD='X86;ARM;AArch64' -DLLVM_ENABLE_PROJECTS="${2}"; } || exit 1
	{ ninja -C build && ninja -C build install; } || exit 1
fi

# To be evaluated by other scripts
printf "export LLVM_CONFIG='%s'\n" "${LLVM_CONFIG}" > "${LLVM_ENV}"
printf "export PATH='%s/bin:%s'\n" "${INSTALL_DIR}" "${PATH}" >> "${LLVM_ENV}"
