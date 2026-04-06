#!/bin/bash
# name: Sunshine
# version: 1.0
# description: sunshine_desc
# icon: sunshine.png
# repo: https://github.com/LizardByte/Sunshine

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
pkg_flat dev.lizardbyte.app.Sunshine
sudo_rq
if is_nvidia; then
    pkg_install nvidia-container-toolkit
    if is_solus; then
        pkg_install nvidia-vaapi-driver
    fi
fi
sudo flatpak run --command=additional-install.sh dev.lizardbyte.app.Sunshine