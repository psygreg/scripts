#!/bin/bash
# name: NeoVim
# version: 1.0
# description: nvim_desc
# icon: neovim.svg
# repo: https://neovim.io

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
_packages=(neovim)
sudo_rq
_install_
zeninf "$msg018"