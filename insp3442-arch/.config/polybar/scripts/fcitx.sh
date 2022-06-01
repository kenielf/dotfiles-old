#!/bin/sh
# Return current input language to be used in polybar - dependes on qdbus and qt5-tools
# For FCITX4:
# qdbus "org.fcitx.Fcitx" "/inputmethod" "GetCurrentIM"
# For FCITX5:
# qdbus "org.fcitx.Fcitx5" "/controller" "org.fcitx.Fcitx.Controller1.CurrentInputMethod"

###--- DBUS ---###
# Get the name of the dbus service
fcitx_status=$(qdbus | egrep "^ org.fcitx.Fcitx(5|)$")

###--- MAIN ---###
# If FCITX4:
if [ "$fcitx_status" == " org.fcitx.Fcitx" ]; then
    input=$(qdbus "org.fcitx.Fcitx" "/inputmethod" "GetCurrentIM")
    if [ "$input" = "fcitx-keyboard-br" ]; then
     	printf "BR"
    elif [ "$input" = "mozc" ]; then
    	printf "JP"
    elif [ "$input" == "" ]; then
        printf "OFF"
    else
        printf "??"
    fi

# If FCITX5:
elif [ "$fcitx_status" == " org.fcitx.Fcitx5" ]; then
    input=$(qdbus "org.fcitx.Fcitx5" "/controller" "org.fcitx.Fcitx.Controller1.CurrentInputMethod")
    if [ "$input" == "keyboard-br" ]; then
        printf "BR"
    elif [ "$input" == "mozc" ]; then
        printf "JP"
    elif [ "$input" == "" ]; then
        printf "OFF"
    else 
        printf "??"
    fi

fi
