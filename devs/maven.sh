#!/bin/bash
# name: Maven
# version: 1.0
# description: mvn_desc
# icon: maven.svg

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
if is_solus; then
    _packages=(apache-maven)
else
    _packages=(maven)
fi
sudo_rq
_install_
zeninf "$msg018"