#!/bin/sh

REMOTEIPS=$1
if [ -z "${REMOTEIPS}" ] ;then
        echo "no remote specified"
        exit 1
fi

/usr/sbin/racoonctl -s /var/run/racoon.sock vd ${REMOTEIPS}
