#!/bin/sh
echo 3>/proc/sys/vm/drop_caches
sync
echo "suspending in 10 seconds... consider closing ssh session"
sleep 10
nohup echo mem > /sys/power/state
