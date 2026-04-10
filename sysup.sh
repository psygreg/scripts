#!/bin/bash
# name: sysup
# description: sysup_desc
# icon: topgrade.svg
# revert: no
# compat: !ostree, !ublue

source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_

needs_reboot() {
    if is_fedora; then
        sudo dnf needs-restarting -r 
    elif is_debian || is_ubuntu; then
        [ -f /var/run/reboot-required ]
    elif is_arch || is_cachy; then
        return 0 # no way of reliably checking for this on Arch-based distros, leave that to the user but always recommend it anyway
    elif is_suse; then
        sudo zypper needs-rebooting
    elif is_solus; then
        return 0 # no way of reliably checking for this on Solus, leave that to the user but always recommend it anyway
    fi
}

echo "$sysup_starting"
if is_fedora; then
    sudo dnf autoremove -y || fatal "Failed to remove orphaned packages"
    sudo dnf upgrade -y || fatal "Failed to upgrade packages"
elif is_debian || is_ubuntu; then
    sudo apt autoremove -y || fatal "Failed to remove orphaned packages"
    sudo apt upgrade -y || fatal "Failed to upgrade packages"
elif is_arch || is_cachy; then
    sudo pacman -Rns $(pacman -Qdtq) --noconfirm || fatal "Failed to remove orphaned packages"
    sudo pacman -Syu --noconfirm || fatal "Failed to upgrade packages"
elif is_suse; then
    sudo zypper rm --clean-deps $(zypper packages --unneeded | awk '/^i/{print $5}') -y || fatal "Failed to remove orphaned packages"
    sudo zypper dup -y || fatal "Failed to upgrade packages"
elif is_solus; then
    sudo eopkg rmo -y || fatal "Failed to remove orphaned packages"
    sudo eopkg up -y || fatal "Failed to upgrade packages"
fi
if which flatpak > /dev/null; then
    flatpak uninstall --unused --delete-data -y || fatal "Failed to remove orphaned flatpak packages"
    flatpak update -y || fatal "Failed to update flatpak packages"
fi
if needs_reboot; then
    zeninf "$sysup_rebootreq"
else
    zeninf "$sysup_completed"
fi