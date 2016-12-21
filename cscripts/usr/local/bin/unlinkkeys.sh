#!/bin/sh
sync
echo 3 > /proc/sys/vm/drop_caches
for i in $(keyctl show | grep ext4 | cut -d'-' -f1) ; do keyctl unlink $i ; done
echo 3 > /proc/sys/vm/drop_caches
