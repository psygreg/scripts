#!/bin/bash
# name: HTTPie
# version: 1.0
# description: httpie_desc
# icon: httpie.svg
# repo: https://httpie.io/desktop

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/helpers.lib"
_lang_
_flatpaks=(
    io.httpie.Httpie
)
_flatpak_
zeninf "$msg018"