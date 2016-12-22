#!/bin/sh -e

mount -o remount,ro,nodev,nosuid,noexec /etc 2> /dev/null
mount -o remount,nodev,nosuid,noexec /tmp 2> /dev/null
mount -o remount,nodev,nosuid,noexec /var/tmp 2> /dev/null
mount -o remount,nodev,nosuid,noexec /home 2> /dev/null
mount -o remount,ro /usr 2> /dev/null
