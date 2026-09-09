#!/bin/bash
# name: Thumbnailer
# version: 1.0
# description: thumb_desc
# icon: handbrake.svg
# nocontainer

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
askpass
pkg_install ffmpegthumbnailer
info "$finishmsg"