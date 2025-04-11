#!/bin/sh

echo "${0%/*}/profile.sh"

command rm -rf "${PDK_ROOT}" && \
git clone --recursive https://github.com/IHP-GmbH/IHP-Open-PDK.git "${PDK_ROOT}" && \
( cd "${PDK_ROOT}" && git checkout dev )
