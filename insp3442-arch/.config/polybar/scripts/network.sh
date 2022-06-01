#!/bin/sh
# Simple script to print or change status of a network type.
# Commands can be toggled on/off by adding "on" or "off" to the end of:
# wifi command: nmcli --color no radio wifi
# ethernet command: nmcli --color no networking

###--- FUNCTIONS ---###
usage() {
    printf "Usage: $0 -t <ethernet|wireless> -s\n"
    printf " -t\t<ethernet|wireless>\tUsed to set which network to get/set status.\n"
    printf " -s\tno options\t\tUsed to set switch status on/off.\n"
    exit 1 #
}

###--- DEFAULTS ---###
network_t="ethernet"
switch_b=false

###--- GETOPTS ---###
while getopts "t:s" opt; do
    case "$opt" in
        t)
            if [ "$OPTARG" == "ethernet" ] || [ "$OPTARG" == "wireless" ]; then
                network_t="$OPTARG"
            else
                usage
            fi
            #[ "$OPTARG" == "ethernet" ] && network_t="$OPTARG" || [ "$OPTARG" == "wireless" ] && network_t="$OPTARG" || usage
            ;;
        s)
            switch_b=true
            ;;
        *)
            usage
            ;;
    esac
done

###--- MAIN ---###
#printf "N: $network_t\nS: $switch_b\n" # Debug
# Ethernet
if [ "$network_t" == "ethernet" ]; then
    network_s=$(nmcli --color no networking)
    # Toggle status
    if [ "$switch_b" == true ]; then
        if [ "$network_s" == "disabled" ]; then
            nmcli networking on
        elif [ "$network_s" == "enabled" ]; then
            nmcli networking off
        else
            exit 1
        fi
    # Print status
    else
        if [ "$network_s" == "disabled" ]; then
            printf "OFF"
        elif [ "$network_s" == "enabled" ]; then
            printf "ON"
        else
            printf "--"
        fi
    fi
# Wireless
elif [ "$network_t" == "wireless" ]; then
    network_s=$(nmcli --color no radio wifi)
    # Toggle status
    if [ "$switch_b" == true ]; then
        if [ "$network_s" == "disabled" ]; then
            nmcli radio wifi on
        elif [ "$network_s" == "enabled" ]; then
            nmcli radio wifi off
        else
            exit 1
        fi
    # Print status
    else
        if [ "$network_s" == "disabled" ]; then
            printf "OFF"
        elif [ "$network_s" == "enabled" ]; then
            printf "ON"
        else
            printf "--"
        fi
    fi
# Else, exit with error
else
    exit 1
fi


