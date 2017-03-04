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

/usr/local/bin/lpdefault.sh $DEVICE

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
