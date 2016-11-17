#!/bin/sh -e

mount -o remount,ro /etc 2> /dev/null
mount -o remount,ro /usr 2> /dev/null
mount -o remount,noexec /tmp 2> /dev/null
mount -o remount,noexec /var/tmp 2> /dev/null
