#!/bin/sh
# Copyright aggi 2017

DEEP=""

while getopts "r:t:l:d:D" opt
do
	case $opt in
		r) REPO=$OPTARG ;;
		t) TAGNAME=$OPTARG ;;
		l) LOGFILE=$OPTARG ;;
		d) DEVICE=$OPTARG ;;
		D) DEEP="yes" ;;
		*) echo "USAGE $0 <-r repository> <-t tagname> <-l logfile> [-d device] [-D]"; exit 1
	esac
done
LOGDIR=$(dirname $LOGFILE)

if [ -z "${REPO}" -o -z "${TAGNAME}" -o -z "${LOGDIR}" ] ; then
	echo "USAGE $0 <-r repository> <-t tagname> <-l logfile> [-d device] [-D]"; exit 1
fi

if [ ! -x ${REPO} ] ; then
	echo "repo error"
	exit 1
fi

if [ ! -x ${LOGDIR} ] ; then
	echo "logdir error"
	exit 1
fi

if [ -z "$GNUPGHOME" ] ; then
	echo "GNUPGHOME is not set"
	exit 1
fi

REPONAME="$(basename $REPODIR)"
LOGDATE="$(date +%Y%m%d) "
LOGFILE="/tmp/${RANDOM}"

if [ -z "$DEVICE" ] ; then
	DEVICE="/dev/logger"
fi

if [ "x${DEEP}" = "xyes" ] ; then
	DEEP=" -D"
else
	DEEP=""
fi

gitsigtaglog.sh -r ${REPODIR} -t ${LOGDATE} -l ${LOGFILE} ${DEEP}
lprlog.sh -f ${LOGFILE} -p "${LOGDATE} ${REPONAME}:" -d ${DEVICE}
rm -f ${LOGFILE}
