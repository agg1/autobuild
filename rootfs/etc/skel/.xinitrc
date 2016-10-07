xhost +si:localuser:$USER
xautolock -locker "/usr/bin/xlock -mode blank" -time 5 -killtime 120&
#export force_s3tc_enable=true
export vblank_mode=0
#SDL_VIDEODRIVER=fbcon SDL_FBDEV=/dev/fb1
#xrandr --output LVDS --off
xrdb ~/.Xdefaults
umask 0007
exec i3
#exec startkde
#exec startxfce4
