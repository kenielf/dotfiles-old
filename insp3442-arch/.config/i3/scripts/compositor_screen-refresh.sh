#!/bin/sh
# picom
if [ $(pgrep -x "picom") ]; then
    killall -s15 picom
else
    setsid -f $HOME/.config/picom/picom.sh &>/dev/null
fi
# display
xrandr --output "$(xrandr | grep -oP "^([\w\-]+)(?=\sconnected\sprimary)")" --set "scaling mode" "Full" --mode $(xrandr | grep -oP "(?<=^\s{3})(\d+x\d+)" | head -n1)
# exit
exit 0
