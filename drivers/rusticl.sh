#!/bin/bash
# name: RustiCL
# version: 1.0
# description: rusticl_desc
# icon: device.svg
# reboot: yes
# gpu: Amd, Intel

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/linuxtoys.lib"
_lang_
# function
rusticl_in () {
    if [[ "$ID_LIKE" == *debian* ]] || [[ "$ID_LIKE" == *ubuntu* ]] || [ "$ID" == "debian" ] || [ "$ID" == "ubuntu" ]; then
        _packages=(mesa-opencl-icd clinfo)
    elif [[ "$ID_LIKE" =~ (rhel|fedora) ]] || [[ "$ID" =~ (fedora) ]]; then
        _packages=(mesa-libOpenCL clinfo)
    elif [[ "$ID_LIKE" == *suse* ]]; then
        _packages=(Mesa-libRusticlOpenCL clinfo)
    elif [[ "$ID" =~ ^(arch|cachyos)$ ]] || [[ "$ID_LIKE" == *arch* ]] || [[ "$ID_LIKE" == *archlinux* ]]; then
        _packages=(opencl-mesa clinfo)
    elif is_solus; then
        _packages=(ocl-icd clinfo)
    fi
    _install_
}
if is_amd; then
    sudo_rq
    rusticl_in
    prep_edit /etc/environment
    curl -sL https://raw.githubusercontent.com/psygreg/linuxtoys/master/resources/rusticl-amd \
        | sudo tee -a /etc/environment > /dev/null
    zeninf "$msg036"
else
    if is_intel; then
        sudo_rq
        rusticl_in
        prep_edit /etc/environment
        curl -sL https://raw.githubusercontent.com/psygreg/linuxtoys/master/resources/rusticl-intel \
            | sudo tee -a /etc/environment > /dev/null
        zeninf "$msg036"
    else
        nonfatal "$msg077"
        exit 1
    fi
fi
