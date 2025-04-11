#!/bin/sh
# Managing nix packages
# See https://github.com/lf-/flakey-profile
alias nix_profile_switch='nix run --impure "${NIXPKGS}#profile.switch"'
alias nix_profile_rollback='nix run --impure "${NIXPKGS}#profile.rollback"'
alias nix_profile_build='nix build --impure "${NIXPKGS}#profile"'
alias nix_profile_update='nix flake update --flake "${NIXPKGS}"'
