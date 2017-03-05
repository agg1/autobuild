#!/bin/bash - 
#===============================================================================
#
#          FILE: checkgw.sh
# 
#         USAGE: ./checkgw.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: -- (), 
#  ORGANIZATION: 
#       CREATED: 03/04/17 23:28
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

FWGROUP="$1"
GW=$(ip route | awk '/default/ { print $3 }')
sg ${FWGROUP} -c "ping -c 1 -W 3 ${GW}" || exit 1
