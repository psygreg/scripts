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
release_upgrade() {
    local current_year=$(date +%Y)
    local current_month=$(date +%m)
    # Only offer upgrade in May (05) or November (11) for stability
    if [[ "$current_month" == "05" || "$current_month" == "11" ]]; then
        if is_ubuntu; then
            { do-release-upgrade -c && return 0; } || return 1      
        elif is_fedora; then
            local count=0
            for ((y = 2026; y <= current_year; y++)); do
                if [[ $y -lt $current_year ]]; then
                    count=$((count + 2))
                else
                    if [[ $current_month -ge 5 ]]; then
                        ((count++)) 
                    fi
                    if [[ $current_month -ge 11 ]]; then
                        ((count++)) 
                    fi
                fi
            done
            fedora_version=$((43 + count))
            return 0
        fi
    fi
    return 1
}
offer_release_upgrade() {
    zenity --question --text="$sysup_available" --title="Release Upgrade" || return 1
}

echo "$sysup_starting"
if is_fedora; then
    sudo dnf autoremove -y || fatal "Failed to remove orphaned packages"
    sudo dnf upgrade -y || fatal "Failed to upgrade packages"
    if release_upgrade; then
        if offer_release_upgrade; then
            sudo dnf system-upgrade download --releasever=$fedora_version -y || fatal "Failed to download Fedora $fedora_version upgrade"
            sudo dnf system-upgrade reboot || fatal "Failed to reboot for Fedora $fedora_version upgrade"
        fi
    fi
elif is_debian || is_ubuntu; then
    sudo apt autoremove -y || fatal "Failed to remove orphaned packages"
    sudo apt upgrade -y || fatal "Failed to upgrade packages"
    if is_ubuntu && [[ "$ID" == "ubuntu" ]] && release_upgrade; then
        if offer_release_upgrade; then
            sudo do-release-upgrade || fatal "Failed to start Ubuntu release upgrade"
        fi
    fi
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