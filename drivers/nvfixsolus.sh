#!/bin/bash
# name: Solus OS Nvidia Fix
# version: 1.0
# description: nvfixsolus_desc
# icon: nvidia.svg
# compat: solus
# reboot: yes
# nocontainer
# gpu: Nvidia
# new

source "$SCRIPT_DIR/libs/optimizers.lib"
_lang_
sudo_rq
nvidia_solus_lib
zeninf "$rebootmsg"