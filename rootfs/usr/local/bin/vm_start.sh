#!/bin/sh - 
#===============================================================================
#
#          FILE: vm_start.sh
# 
#         USAGE: ./vm_start.sh 
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

[ -z "${VMNAME}" -o ! -e "/usr/local/etc/machines/${VMNAME}" ] && echo "machine missing" && exit 1
/usr/local/bin/vm_stop.sh ${VMNAME}
source /usr/local/etc/machines/${VMNAME}
