#!/bin/bash
# name: ZRAM-Config
# description: zram_desc
# icon: preload.svg
# compat: ubuntu, debian, arch, !solus
# nocontainer

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
if is_arch; then
    pkg_install zram-generator
    if [ -f /etc/systemd/zram-generator.conf ]; then
        prep_edit /etc/systemd/zram-generator.conf
    else
        prep_create /etc/systemd/zram-generator.conf
    fi
    sudo tee /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
zram-size = min(ram / 3, 16384)
EOF
    sudo systemctl daemon-reload
    sysd_enable systemd-zram-setup@zram0.service
    sysd_start systemd-zram-setup@zram0.service
    zeninf "$finishmsg"
elif is_ubuntu; then
    pkg_install zram-config
    zeninf "$msg036"
elif is_debian; then
    pkg_install zram-tools
    if [ -f /etc/default/zramswap ]; then
        prep_edit /etc/default/zramswap
    else
        prep_create /etc/default/zramswap
    fi
    sudo tee /etc/default/zramswap << 'EOF'
ALGO=zstd
PERCENT=50
EOF
    sysd_stop zramswap
    sysd_start zramswap
    zeninf "$finishmsg"
else
    fatal "$msg077"
fi
