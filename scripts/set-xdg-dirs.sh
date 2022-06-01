#!/bin/sh
# Simple script to set XDG directory if they all exist
###--- FUNCTION ---###
function raise_err() {
    echo "$@" 1>&2 
    exit 1
}

function set_xdg_dir() {
    local type="$1"
    local folder="$(echo "$2" | sed -e "s/~/\/home\/$USER/g")"
    [ -d $folder ] && echo "Setting 'XDG_${type}_DIR' to $folder." && xdg-user-dirs-update --set $type $folder || raise_err "Could not set $folder as $type XDG directory."
}

###--- MAIN ---###
# Set the directories to your preference.
set_xdg_dir DESKTOP ~/Other/Desktop
set_xdg_dir DOCUMENTS ~/Documents
set_xdg_dir DOWNLOAD ~/Downloads
set_xdg_dir GAMES ~/Games
set_xdg_dir IRCDCC ~/Other/DCC
set_xdg_dir MUSIC ~/Music
set_xdg_dir PICTURES ~/Pictures
set_xdg_dir PROGRAMMING ~/Programming
set_xdg_dir PROJECTS ~/Projects
set_xdg_dir PUBLICSHARE ~/Other/Share
set_xdg_dir SCREENSHOT ~/Pictures/Screenshots
set_xdg_dir TEMPLATES ~/Other/Templates
set_xdg_dir VIDEOS ~/Videos
set_xdg_dir WORK ~/Work
# Finally, update the user configuration, to be sure.
xdg-user-dirs-update
