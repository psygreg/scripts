#!/bin/bash
# name: Nala
# description: nala_desc
# version: 1.0
# icon: terminal.svg
# compat: ubuntu, debian
# repo: https://gitlab.com/volian/nala

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
_packages=(nala)
sudo_rq
_install_
zeninf "$msg018"