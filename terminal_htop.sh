#!/bin/bash
xfce4-terminal --hide-borders --hide-toolbar --hide-menubar --title=desktopconsole --maximize -e "htop && t" &
sleep 2
wmctrl -r desktopconsole -b add,below,sticky
wmctrl -r desktopconsole -b add,skip_taskbar,skip_pager

