#!/bin/sh
###--- VARIABLES ---###
# Write your must have folders on '/home/$USER/' - these will be created if not existing.
# IMPORTANT: Paths must not contain shell expansions due to POSIX compliance.
f_home="
.builds
.config
.scripts
Documents/Professional
Documents/Personal
Dotfiles
Downloads
Games
Music
Other/Books
Other/DCC
Other/Desktop
Other/Docker
Other/LightNovel
Other/Share
Other/Templates
Other/Vaults
Other/日本語
Pictures/Memes
Pictures/Personal
Pictures/Screenshots
Programming
Projects
Videos/Animes
Videos/OBS
Work
"

###--- MAIN ---###
# Check if user is not root.
if [ $UID == 0 ]; then
    >&2 printf "%s\n" "Can not be run as root. Try again as a regular user."
    exit
fi
# Start
printf "%s\n" "Creating folders that do not yet exist."
set -- $f_home
for path_ in "$@"; do
    [ ! -d "/home/$USER/$path_" ] && printf "\r%s\n" "Creating '$path_'" && mkdir -p "/home/$USER/$path_"
done
