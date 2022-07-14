#!/bin/sh

#[[ -f /usr/local/bin/dwmblocks  ]] && ~/suckless/dwmblocks/dwmblocks &
[[ -f /usr/bin/feh ]] && ~/.fehbg 
[[ -f /usr/bin/xinput ]] && xinput set-prop "ELAN2204:00 04F3:30F5 Touchpad" "libinput Tapping Enabled" 1
[[ -f /usr/local/bin/picom ]] && picom  --config ~/confs/picom/picom.conf --experimental-backends &
[[ -f /usr/bin/xset ]] && xset -dpms && xset s off; 
[[ -f $HOME/.Xresources ]] && xrdb ~/.Xresources
[[ -f ~/scripts/turbo.sh ]] && ~/scripts/turbo.sh 


export _JAVA_AWT_WM_NONREPARENTING=1
[[ -f /usr/local/bin/dwm ]] && until dwm;do sleep 1;done
