#!/bin/sh
# Copyright aggi 2017

feedpage=""

while getopts "f:d:p:n" opt
do
	case $opt in
		f) LOGFILE=$OPTARG ;;
		d) DEVICE=$OPTARG ;;
		p) PREFIX=$OPTARG ;;
		n) feedpage="yes";;
		*) echo "USAGE $0 <-f logfile> [-p prefix] [-d device] [-n]"; exit 1
	esac
done

if [ -z "$LOGFILE" ] ; then
        echo "USAGE $0 <-f logfile> [-p prefix] [-d device] [-n]"; exit 1
fi

if [ -z "$DEVICE" ] ; then
	DEVICE="/dev/logger"
fi

# half speed mode off
echo -ne "\x1B\x73\x00" > "$DEVICE" 
# quality mode off, speed on
echo -ne "\x1B\x78\x00" > "$DEVICE" 
# 15cpi 0x67, 12cpi 0x4D, 10cpi 0x50
echo -ne "\x1B\x67" > "$DEVICE" 
# proportional spacing off with 15cpi
echo -ne "\x1B\x70\x00" > "$DEVICE" 
# unidirectional off
echo -ne "\x1B\x55\x00" > "$DEVICE" 
sleep 1

#if [ "x${feedpage}" = "xyes" ] ; then
#	echo -ne "\x0C" > "$DEVICE"
#fi

PREFILE="/tmp/$(basename $LOGFILE).tmp"
if [ ! -z "$PREFIX" ] ; then
	cat $LOGFILE | sed "s/^/${PREFIX}: /g" > $PREFILE
	cat $PREFILE > $DEVICE
	sleep 1
	rm -f $PREFILE
else
	cat $LOGFILE > $DEVICE
fi

sleep 1

if [ "x${feedpage}" = "xyes" ] ; then
	echo -ne "\x0C" > "$DEVICE"
fi
