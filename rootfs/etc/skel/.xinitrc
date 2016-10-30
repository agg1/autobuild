xhost +si:localuser:$USER
xautolock -locker xtrlock -time 5 -killtime 120&
export force_s3tc_enable=true
export vblank_mode=0
#SDL_VIDEODRIVER=fbcon SDL_FBDEV=/dev/fb1
#xrandr --output LVDS --off
xrdb ~/.Xdefaults
setxkbmap -layout us,de -option "grp:alt_shift_toggle,grp_led:scroll,compose:ralt"
gpg-agent --daemon
umask 0007
exec i3
