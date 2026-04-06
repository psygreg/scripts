#!/bin/bash
# name: Broadcom WiFi
# version: 1.0
# description: bcm_desc
# icon: bcm.png
# compat: fedora, ostree, ublue, arch, cachy
# reboot: yes
# nocontainer

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/helpers.lib"
_lang_
sudo_rq
if is_fedora || is_ostree; then
    rpmfusion_chk
    _packages=(akmod-wl)
elif is_arch || is_cachy; then
    _packages=(linux-headers broadcom-wl-dkms)
fi
_install_
zeninf "$msg036"