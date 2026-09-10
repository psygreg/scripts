#!/bin/bash
# name: Paru
# version: 1.0
# description: paru_desc
# icon: archpkg.png
# compat: arch
# repo: https://github.com/Morganamilo/paru

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
warn "$msg294"

askpass
pkg_install base-devel

prep_tmp_noram
builddir=$(mktemp -d ./paru-bin.XXXXXX) || die "Failed to create builddir"
git clone --branch paru-bin --single-branch https://github.com/archlinux/aur.git "$builddir" || die "Failed to clone paru"
cd "$builddir" || die "Failed to reach builddir"

makepkg -s --noconfirm || die "Failed to build package paru"
pkg_fromfile "$builddir"/paru-bin-*.tar.zst || die "Failed to install package paru"

{ command -v paru >/dev/null 2>&1 && paru --version >/dev/null 2>&1; } || die "paru installed but not operational"
info "$finishmsg"
