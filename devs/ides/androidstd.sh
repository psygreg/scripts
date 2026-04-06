#!/bin/bash
# name: Android Studio
# version: 1.0
# description: droidstd_desc
# icon: android-studio.svg
# repo: https://developer.android.com/studio/

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/helpers.lib"
_lang_
_flatpaks=(
    com.google.AndroidStudio
)
_flatpak_
zeninf "$msg018"