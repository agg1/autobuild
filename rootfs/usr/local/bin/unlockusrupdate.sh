#!/bin/sh -e

mount -o remount,rw /etc 2> /dev/null
mount -o remount,rw /usr 2> /dev/null
mount -o remount,exec /tmp 2> /dev/null
mount -o remount,exec /var/tmp 2> /dev/null
