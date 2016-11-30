xhost +si:localuser:$USER
xhost +inet:10.0.0.1
xautolock -locker xtrlock -time 5 -killtime 120&
export force_s3tc_enable=true
#export vblank_mode=0
#SDL_VIDEODRIVER=fbcon SDL_FBDEV=/dev/fb1
xrandr --output LVDS --off
xgamma -gamma 0.95
#feh --bg-scale skull.jpg
xsetroot -solid #1d1d30
xrdb ~/.Xdefaults
setxkbmap -layout us,de -option "grp:alt_shift_toggle,grp_led:scroll,compose:ralt"
umask 0007
exec i3
