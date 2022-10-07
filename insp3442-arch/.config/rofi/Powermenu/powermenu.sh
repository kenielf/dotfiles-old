#!/bin/sh


###--- OPTIONS ---###
# Icons
pwr_ico=""
rbt_ico=""
lck_ico=""
spd_ico=""
lgo_ico=""
# Labels
pwr_lbl="Poweroff"
rbt_lbl="Reboot"
lck_lbl="Lock Screen"
spd_lbl="Suspend"
lgo_lbl="Log Out"
#pwr_lbl="Desligar"
#rbt_lbl="Reiniciar"
#lck_lbl="Bloquear Tela"
#spd_lbl="Suspender"
#lgo_lbl="Sair"

options="$pwr_ico $pwr_lbl\n$rbt_ico $rbt_lbl\n$lck_ico $lck_lbl\n$spd_ico $spd_lbl\n$lgo_ico $lgo_lbl"


###--- VARIABLES ---###
# Uptime
uptime=$(uptime -p | sed -e 's/up //g')
# Rofi
rofi_prompt=""
rofi_theme="/home/$USER/.config/rofi/Powermenu/powermenu.rasi"
confirm_theme="/home/$USER/.config/rofi/Powermenu/confirm.rasi"
rofi_cmd="rofi -config $rofi_theme -theme $rofi_theme -p $rofi_prompt -dmenu -i -selected-row 2"
confirm_cmd="rofi -config $confirm_theme -theme $confirm_theme -dmenu -i -no-fixed-num-lines -p 'Are You Sure?'"
#rofi_cmd="rofi -theme ~/.config/rofi/Powermenu/powermenu.rasi -p $rofi_prompt -dmenu -i -selected-row 2"
#confirm_cmd="rofi -theme ~/.config/rofi/Powermenu/confirm.rasi -dmenu -i -no-fixed-num-lines -p 'Are You Sure?'"
# Sed
sed_xpr="s/[$pwr_ico$rbt_ico$lck_ico$spd_ico$lgo_ico][ ]*//g"


### Functions
confirm() {
	rofi -config "/home/$USER/rofi/Powermenu/confirm.rasi" -theme "~/.config/rofi/Powermenu/confirm.rasi" \
		-dmenu -i -no-fixed-num-lines \
		-p 'Are You Sure?'
	confirm_cmd
}
###--- POWERMENU ---###
chosen="$(echo -e $(echo -e $options | $rofi_cmd) | sed -E "$sed_xpr")"
case $chosen in
	$pwr_lbl)
		pkexec systemctl poweroff
	;;
	$rbt_lbl)
		pkexec systemctl reboot
	;;
	$lck_lbl)
        if [ -f "/usr/bin/betterlockscreen" ]; then
            ~/.config/rofi/Powermenu/lock-script &
        elif [ -f "/usr/bin/i3lock" ]; then
            i3lock &
        fi
	;;
	$spd_lbl)
		pkexec systemctl suspend
	;;
	$lgo_lbl)
		if [ "$DESKTOP_SESSION" == "bspwm" ]; then
			bspc quit
		elif [ "$DESKTOP_SESSION" == "i3" ];then
			i3-msg exit
		fi
	;;
esac
