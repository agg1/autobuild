#!/bin/sh
CDATE=$1
[ -z "${CDATE}" ] && echo "error param" && exit 1
date -d "@${1}" "+%Y%m%d %H:%M:%S"
