#!/bin/sh
echo 3>/proc/sys/vm/drop_caches
sync
echo mem > /sys/power/state
