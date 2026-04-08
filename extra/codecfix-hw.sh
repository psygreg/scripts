#!/bin/bash
# name: codecfix-hw
# version: 1.0
# description: codecfix-hw_desc
# icon: codec.svg
# compat: fedora, !solus
# reboot: yes
# revert: no

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/helpers.lib"
_lang_
sudo_rq
rpmfusion_chk
if command -v rpm-ostree &> /dev/null; then
    sudo rpm-ostree override remove \
    ffmpeg-free \
    libavcodec-free \
    libavfilter-free \
    libavformat-free \
    libavutil-free \
    libpostproc-free \
    libswresample-free \
    libswscale-free \
    libavdevice-free \
    noopenh264 \
    --install ffmpeg openh264 gstreamer1-plugin-openh264 libavcodec-freeworld mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld mesa-vulkan-drivers-freeworld libavcodec-freeworld gstreamer1-plugins-bad-freeworld
else
    if rpm -qi "$pkg" &> /dev/null; then
        sudo dnf swap ffmpeg-free ffmpeg
    fi
fi
zeninf "$msg036"
