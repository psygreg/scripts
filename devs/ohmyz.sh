#!/bin/bash
# name: Oh My Zsh
# version: 1.0
# description: omz_desc
# icon: zsh.png
# compat: arch, debian, fedora, ubuntu, cachy, suse, ostree
# repo: https://ohmyz.sh
# revert: internal

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
source "$SCRIPT_DIR/libs/lang/${langfile}.lib"
# TODO -- chsh event tracking
sudo_rq
_packages=(zsh curl git)
_install_
prep_edit "$HOME/.zshrc"
(
	sh -c "$(curl -fsSL https://install.ohmyz.sh/) --unattended" && {
		shell_change "$(type -p zsh)" "$USER";	
	}
) && { zeninf "$msg018"; } || { fatal "Unable to complete installation"; }
