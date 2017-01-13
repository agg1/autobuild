#!/bin/sh

REMOTEIPS=$1
if [ -z "${REMOTEIPS}" ] ;then
        echo "no remote specified"
        exit 1
fi

#gwif=`netstat --inet -rn|awk '($1 == "0.0.0.0"){print $8; exit}'`
#
#if [ -z "${gwif}" ] ; then
#	echo "no default gw for road warrior setup"
#	exit 1
#fi

racoonctl -s /var/run/racoon.sock vd ${REMOTEIPS} 2>/dev/null
sleep 2
racoonctl -s /var/run/racoon.sock vc ${REMOTEIPS}
