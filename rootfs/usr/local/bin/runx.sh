#!/bin/sh
TTY=$(tty)
if [ $(echo $TTY | grep '/dev/tty') ] ;then
    TTYNUM=$(echo $TTY | grep '/dev/tty' | sed 's/\/dev\/tty//')
fi

[ "${TTYNUM}X" != "X" ] && exec startx -- :${TTYNUM} vt${TTYNUM}
