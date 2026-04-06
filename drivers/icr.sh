#!/bin/bash
# name: Intel Compute Runtime
# version: 1.0
# description: icr_desc
# icon: intel.png
# reboot: yes
# gpu: Intel

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
# function
icr_in () {
    if [[ "$ID_LIKE" == *debian* ]] || [[ "$ID_LIKE" == *ubuntu* ]] || [ "$ID" == "debian" ] || [ "$ID" == "ubuntu" ]; then
        _packages=(intel-opencl-icd clinfo)
    elif [[ "$ID_LIKE" == *suse* ]] || [[ "$ID_LIKE" == *opensuse* ]] || [[ "$ID" =~ "suse" ]]; then
        _packages=(intel-opencl clinfo)
    else
        _packages=(intel-compute-runtime clinfo)
    fi
    _install_
}
if is_intel; then
    sudo_rq
    icr_in
    zeninf "$msg036"
else
    nonfatal "$msg077"
    exit 1
fi