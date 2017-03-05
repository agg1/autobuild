#!/bin/sh - 
#===============================================================================
#
#          FILE: vm_stop.sh
# 
#         USAGE: ./vm_stop.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: -- (), 
#  ORGANIZATION: 
#       CREATED: 03/05/17 02:58
#      REVISION:  ---
#===============================================================================

VMNAME="$1"

[ -z "${VMNAME}" ] && echo "machine name missing" && exit 1

POWEROFF=""
TRYCOUNT=0
while [ "x${POWEROFF}" = "x" ] ; do
	TRYCOUNT=$(($TRYCOUNT+1))
	if [ $TRYCOUNT -gt 10 ]; then
		echo "failed system_powerdown for ${VMNAME} ... killing"
		kill -9 $(cat /var/run/qemu-${VMNAME}.pid) 2>/dev/null
		sleep 5
		exit
	fi
	echo system_powerdown | ncat -U /root/qemu-monitor-${VMNAME} 2>/dev/null && sleep 30 || POWEROFF="true"
done

