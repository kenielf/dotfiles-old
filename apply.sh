#!/usr/bin/env sh
###--- FUNCTIONS ---###
# backup PATH
function backup() {
    if [ -d $1 ]; then
        sudo cp -rf "$1" "$1.BAK" && echo "Backed up \'$1\'."
    elif [ -f $1 ]; then
        sudo cp -rf "$1" "$1.BAK" && echo "Backed up \'$1\'."
    fi
}
# symlink SOURCE_PATH TARGET_PATH
function symlink() {
    sudo ln -sfn "$(echo "$1" | sed -e "s/~/\/home\/$(whoami)/g")" "$(echo "$2" | sed -e "s/~/\/home\/$(whoami)/g")"
}
# copy SOURCE_PATH TARGET_PATH
function copy() {
    sudo cp -rf "$(echo "$1" | sed -e "s/~/\/home\/$(whoami)/g")" "$(echo "$2" | sed -e "s/~/\/home\/$(whoami)/g")"
}
###--- EUID CHECK ---###
if [ $EUID == 0 ]; then
    echo "Script must not be run as root." >&2
    exit 1
fi

###--- MAIN ---###
# <!-- Start -->
echo "Applying dotfiles preset"
echo -e "\
╻┏┓╻┏━┓┏━┓┏━┓╻ ╻╻ ╻┏━┓   ┏━┓┏━┓┏━╸╻ ╻
┃┃┗┫┗━┓┣━┛╺━┫┗━┫┗━┫┏━┛╺━╸┣━┫┣┳┛┃  ┣━┫
╹╹ ╹┗━┛╹  ┗━┛  ╹  ╹┗━╸   ╹ ╹╹┗╸┗━╸╹ ╹\n"
# <!-- Backup -->
echo -e "Starting backup..."
# Home directory
backup "$HOME/.config"
backup "$HOME/.dmrc"
backup "$HOME/.gtkrc-2.0"
backup "$HOME/.zshrc"
backup "$HOME/.zshrc.zni"
# LightDM
backup "/etc/lightdm"
# General ETC files
backup "/etc/udev"
backup "/etc/makepkg.conf"
backup "/etc/mkinitcpio.conf"
backup "/etc/pacman.conf"
backup "/etc/tlp.conf"
backup "/etc/vconsole.conf"
# <!-- Apply dotfiles -->
cur_p=$(pwd)
echo -e "Applying configurations..."
# Home directory
symlink "$cur_p/insp3442-arch/.config" "$HOME/.config"
symlink "$cur_p/insp3442-arch/.dmrc" "$HOME/.dmrc"
symlink "$cur_p/insp3442-arch/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
symlink "$cur_p/insp3442-arch/.zshrc" "$HOME/.zshrc"
symlink "$cur_p/insp3442-arch/.zshrc.zni" "$HOME/.zshrc.zni"
## LightDM
copy "$cur_p/insp3442-arch/LightDM" "/etc/lightdm"
## General ETC files
copy "$cur_p/insp3442-arch/etc/udev" "/etc/udev"
copy "$cur_p/insp3442-arch/etc/utheme" "/etc/utheme"
copy "$cur_p/insp3442-arch/etc/makepkg.conf" "/etc/makepkg.conf"
copy "$cur_p/insp3442-arch/etc/mkinitcpio.conf" "/etc/mkinitcpio.conf"
copy "$cur_p/insp3442-arch/etc/pacman.conf" "/etc/pacman.conf"
copy "$cur_p/insp3442-arch/etc/tlp.conf" "/etc/tlp.conf"
copy "$cur_p/insp3442-arch/etc/vconsole.conf" "/etc/vconsole.conf"
# <!-- Finalize -->
echo "Done!"
exit 0
