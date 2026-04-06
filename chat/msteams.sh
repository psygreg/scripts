#!/bin/bash
# NAME: Microsoft Teams
# VERSION: 1.0
# DESCRIPTION: msteams_desc
# icon: teams.svg
# repo: https://github.com/IsmaelMartinez/teams-for-linux

# --- Start of the script code ---
source "$SCRIPT_DIR/libs/helpers.lib"
_lang_
_flatpaks=(
    com.github.IsmaelMartinez.teams_for_linux
)
_flatpak_