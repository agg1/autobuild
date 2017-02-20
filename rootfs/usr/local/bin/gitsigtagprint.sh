#!/bin/sh
# Copyright aggi 2017

REPODIR=$1
[ -d $REPODIR ] || echo "repository error" && exit 1

REPONAME="$(basename $REPODIR)"
LOGDATE="$(date +%Y%m%d) "
LOGFILE="/tmp/${RANDOM}"
LOGDEV="/dev/logger"

gitsigtaglog.sh -r $REPODIR -t ${LOGDATE} -l $LOGFILE
lprlog.sh -f $LOGFILE -p "${LOGDATE} ${REPONAME}:" -d ${LOGDEV}
sleep 1
rm -f $LOGFILE
