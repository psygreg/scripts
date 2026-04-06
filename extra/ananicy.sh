#!/bin/bash
# name: Ananicy-cpp
# version: 1.0
# description: ananicy_desc
# icon: optimizer.svg
# compat: arch

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
sudo_rq
pkg_install ananicy-cpp cachyos-ananicy-rules-git
sysd_enable ananicy-cpp.service
zeninf "$rebootmsg" # while rebooting is not necessary, it is still recommended.
