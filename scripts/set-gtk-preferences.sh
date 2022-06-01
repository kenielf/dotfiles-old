#!/bin/sh
###--- MAIN ---###
# Set weather unit as celsius
gsettings set org.gnome.GWeather temperature-unit centigrade
gsettings set org.gnome.GWeather4 temperature-unit centigrade
# Set file chooser default path as the current working directory rather than the recent files
gsettings set org.gtk.Settings.FileChooser startup-mode cwd
gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode cwd
# Set dark mode by default on GTK 4
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
