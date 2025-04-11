#!/bin/sh
# Usage 1: create-workspace.sh <project-path> <process> <group>
# Options:
#   <project-path> := any non-existing valid directory path
#   <process>      := process technology node. Can be 14, 32, and 90
#   <group>        := any existing group
#
# Usage 2: create-workspace.sh <project-path> <home-user>
# Options:
#   <project-path> := any existing valid project path
#   <home-user>    := any existing home user

[ "$#" -eq 2 ] || [ "$#" -eq 3 ] || {
        printf 'Usage: create-workspace.sh <project-path> <process> <group>\n'
        printf 'Usage: create-workspace.sh <project-path> <home-user>\n'
        exit 1
}

[ "$(whoami)" = 'root' ] || { printf 'Root permission is needed!\n'; exit 1; }

PROJECT_PATH="$1"

if [ "$#" -eq 2 ]; then USER="$2"
        # Validate arguments
        [ -d "${PROJECT_PATH}" ] || { printf 'Project workspace is not initialized!\n'; exit 1; }
        getent passwd "${USER}" > /dev/null || { printf "USER %s doesn't exists!\n" "${USER}"; exit 1; }

        GROUP="$(stat -c '%G' "${PROJECT_PATH}")" || { printf 'Failed to extract group!\n'; exit 1; }
        WORKSPACES="${PROJECT_PATH}/workspaces"
        WORKSPACE="${WORKSPACES}/${USER}"

        [ -d "${WORKSPACE}" ] && { printf 'User workspace already exists!\n'; exit 1; }

        link_workspace () ( cd "${WORKSPACE}" && { [ -e "../../${1}" ] || return 0; } && ln -s "../../${1}" "$1" )

        { mkdir -p "${WORKSPACE}/.lib" && chmod -R 750 "${WORKSPACES}" && chgrp "${GROUP}" "${WORKSPACES}" && \
        chown "${USER}:${GROUP}" "${WORKSPACE}" && chown "${USER}:${USER}" "${WORKSPACE}/.lib" && link_workspace lib && \
        link_workspace lib.defs && link_workspace documentation && link_workspace techfiles && link_workspace rulefiles; } || {
                printf 'Failed to initialize user workspace! Cleanup...\n'
                { command rm -rf "${WORKSPACE}" && printf 'Cleanup successful!\n'; } || printf 'Cleanup unsuccessful!\n'
                exit 1
        }; exit 0
fi

PROCESS_NODE="$2"
GROUP="$3"

# Source PDK variables if not defined (or run 'sudo -E')
# Variables: SAED14_PDK, SAED32_28_PDK, and SAED90_PDK
#. /etc/profile.d/setup.sh

# Validate arguments
[ -d "${PROJECT_PATH}" ] && { printf 'Project path exists!\n'; exit 1; }
case "${PROCESS_NODE}" in
        14) PDK="${SAED14_PDK}"
            [ -z "${PDK}" ] && { printf "SAED14_PDK variable is not defined!\n"; exit 1; } ;;
        32) PDK="${SAED32_28_PDK}"
            [ -z "${PDK}" ] && { printf "SAED32_28_PDK variable is not defined!\n"; exit 1; } ;;
        90) PDK="${SAED90_PDK}"
            [ -z "${PDK}" ] && { printf "SAED90_PDK variable is not defined!\n"; exit 1; } ;;
        *) printf "Invalid process technology node! Values: 14, 32, 90\n"; exit 1 ;;
esac; [ -d "${PDK}" ] || { printf "PDK path doesn't exists!\n"; exit 1; }
getent group "${GROUP}" > /dev/null || { printf "Group %s doesn't exists!\n" "${GROUP}"; exit 1; }

# Function to create a link to PDK files
pdk_create_link () { { [ -e "${PDK}/${1##*/}" ] || return 0; } && ln -s "${PDK}/${1##*/}" "${PROJECT_PATH}/${1}"; }

# Create and link the project files
{ mkdir -p -m 770 "${PROJECT_PATH}" && mkdir -m 750 "${PROJECT_PATH}/rulefiles" && \
mkdir -m 770 "${PROJECT_PATH}/lib" && chgrp -R "${GROUP}" "${PROJECT_PATH}" && \
command cp "${PDK}/install/lib.defs" "${PROJECT_PATH}" && chmod 660 "${PROJECT_PATH}/lib.defs" && chgrp "${GROUP}" "${PROJECT_PATH}/lib.defs" && \
pdk_create_link documentation && pdk_create_link techfiles && \
case "${PROCESS_NODE}" in
        14) pdk_create_link rulefiles/hspice && pdk_create_link rulefiles/icv && pdk_create_link rulefiles/starrc ;;
        32) pdk_create_link rulefiles/custom_compiler && pdk_create_link rulefiles/hercules && \
            pdk_create_link rulefiles/hspice && pdk_create_link rulefiles/icv && pdk_create_link rulefiles/starrc ;;
        90) pdk_create_link rulefiles/hercules && pdk_create_link rulefiles/hspice && \
            pdk_create_link rulefiles/icv && pdk_create_link rulefiles/starrcxt ;;
esac; } || {
        printf 'Failed to initialize workspace! Cleanup...\n'
        { command rm -rf "${PROJECT_PATH}" && printf 'Cleanup successful!\n'; } || printf 'Cleanup unsuccessful!\n'
        exit 1
}
