#!/bin/sh - 
#===============================================================================
#
#          FILE: flushmem.sh
# 
#         USAGE: ./flushmem.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: -- (), 
#  ORGANIZATION: 
#       CREATED: 02/25/2017 03:12
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

echo 3 > /proc/sys/vm/drop_caches
