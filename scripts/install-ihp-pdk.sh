#!/bin/sh

echo "${0%/*}/profile.sh"

command rm -rf "${PDK_ROOT}" && \
git clone --recursive https://github.com/IHP-GmbH/IHP-Open-PDK.git "${IHP_PDK_DIR}" && \
( cd "${IHP_PDK_DIR}" && git checkout dev )
