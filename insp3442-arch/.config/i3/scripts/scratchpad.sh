#!/bin/sh

while ! xdotool search --name "Scratcher"; do
    kitty --override "font_size=12" --override "background_opacity=0.8" --name "Scratcher" --title "Scratcher" 2>/dev/null || \
    kitty --override "font_size=12" --override "background_opacity=0.8" --name "Scratcher" --title "Scratcher" 2>/dev/null || \
    kitty --override "font_size=12" --override "background_opacity=0.8" --name "Scratcher" --title "Scratcher" 2>/dev/null || \
    exit
done
