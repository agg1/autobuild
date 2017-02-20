#!/bin/sh
# Copyright aggi 2017

while getopts "f:d:p:" opt
do
	case $opt in
		f) LOGFILE=$OPTARG ;;
		d) DEVICE=$OPTARG ;;
		p) PREFIX=$OPTARG ;;
		*) echo "USAGE $0 <-f logfile> [-p prefix] [-d device]"; exit 1
	esac
done

if [ -z "$LOGFILE" ] ; then
        echo "USAGE $0 <-f logfile> [-p prefix] [-d device]"; exit 1
fi

if [ -z "$DEVICE" ] ; then
	DEVICE="/dev/logger"
fi

PREFILE="/tmp/$(basename $LOGFILE).tmp"
if [ ! -z "$PREFIX" ] ; then
	cat $LOGFILE | sed "s/^/${PREFIX}: /g" > $PREFILE
	cat $PREFILE > $DEVICE
	sleep 1
	rm -f $PREFILE
else
	cat $LOGFILE > $DEVICE
fi
