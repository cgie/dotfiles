#!/bin/sh

# German keyboard layout

setxkbmap -layout "de" -variant "nodeadkeys" -option "ctrl:nocaps"

# Some X settings

/home/cgie/.screenlayout/dualdigital.sh
xsetroot -cursor_name left_ptr
xset r rate 300 75
xset -b
xrdb -load .Xdefaults

# Wacom Bamboo Pen & Touch configuration

/home/cgie/wacom-init

# Sync clipboards

autocutsel -fork &
autocutsel -selection PRIMARY -fork &

# Auto-start applications

# trayer --edge top --align right --widthtype pixel --width 200 --SetDockType true --SetPartialStrut true --expand true --heighttype pixel --height 18 &
trayer --edge top --align right --widthtype request --expand true --SetDockType true --SetPartialStrut true --transparent true --alpha 0 --tint 0xfdf6e3 --expand true --heighttype pixel --height 14  --padding 1 &


nitrogen --restore &
xcompmgr &
#cairo-compmgr &
sleep 120 && dropboxd &

#mathematica &
#xournal $HOME/drift.pdf &

xmonad
