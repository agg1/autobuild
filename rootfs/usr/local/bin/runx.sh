#!/bin/sh
TTY=$(tty)
if [ $(echo $TTY | grep '/dev/tty') ] ;then
    TTYNUM=$(echo $TTY | grep '/dev/tty' | sed 's/\/dev\/tty//')
fi

if [ "${TTYNUM}X" != "X" ]
    exec xinit -display $TTYNUM
fi
