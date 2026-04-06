#!/bin/bash
# name: .NET SDK
# version: 1.0
# description: dotnet_desc
# icon: dotnet.svg
# compat: fedora, suse, ostree, debian, ubuntu, ublue, arch, cachy

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
prep_tmp
sudo_rq
if is_debian; then
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt update
elif [[ "$NAME" =~ "openSUSE Leap" ]]; then
    sudo zypper in libicu -y
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    wget https://packages.microsoft.com/config/opensuse/15/prod.repo
    sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
    sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
fi
if is_arch || is_cachy; then
    _packages=(dotnet-sdk-9.0-bin)
else
    _packages=(dotnet-sdk-9.0)
fi
_install_
zeninf "$msg018"