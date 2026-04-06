#!/bin/bash
# name: Nvidia Drivers (v580)
# description: nv580_desc
# icon: nvidia.svg
# nocontainer
# gpu: Nvidia
# compat: debian, arch, cachy
# reboot: yes

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/helpers.lib"
_lang_
sudo_rq
if is_debian; then
    prep_tmp
    wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sleep 1
    sudo apt-get update
    _packages=(nvidia-driver-pinning-580 cuda-drivers-580)
    _install_
    sleep 1
    initramfs_upd
    bootloader_upd
    zeninf "$msg036"
elif is_arch || is_cachy; then
    _packages=(nvidia-580xx-dkms nvidia-580xx-utils nvidia-580xx-settings)
    _install_
    zeninf "$msg036"
else
    fatal "$msg077"
fi