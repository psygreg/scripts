#!/bin/bash
# NAME: GIMP (& PhotoGIMP)
# VERSION: 3.0
# DESCRIPTION: gimp_desc
# icon: gimp.svg
# repo: https://www.gimp.org

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
pkg_flat org.gimp.GIMP
if zenity --question --text "$msg253" --width 360 --height 300; then
    zeninf "$msg254"
    timeout 15 flatpak run org.gimp.GIMP
    prep_dir_edit "$HOME/.config/GIMP" "$HOME/.local/share/applications"
    prep_tmp_noram
    wget https://github.com/Diolinux/PhotoGIMP/releases/latest/download/PhotoGIMP-linux.zip || die "Unable to clone remote for PhotoGIMP"
    unzip PhotoGIMP-linux.zip
    mv PhotoGIMP-linux/.config/GIMP/3.0 PhotoGIMP-linux/.config/GIMP/3.2 # rename fixes a bug applying it due to version mismatch
    copy_ -rf PhotoGIMP-linux/.config/* ~/.config/ || fatal "Unable to copy .config files"
    copy_ -rf PhotoGIMP-linux/.local/* ~/.local/ || fatal "Unable to copy .local files"
fi
zeninf "$finishmsg"
