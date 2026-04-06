#!/bin/bash
# name: Insomnia
# version: 1.0
# description: insomnia_desc
# icon: insomnia.svg
# repo: https://insomnia.rest/

# --- Start of the script code ---
#SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/libs/helpers.lib"
_lang_
_flatpaks=(
    rest.insomnia.Insomnia
)
_flatpak_
zeninf "$msg018"