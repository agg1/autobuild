#!/bin/sh
# Copyright aggi 2017

REPO=$1
TAGNAME=$2
LOGFILE=$3
LOGDIR=$(dirname $LOGFILE)

while getopts "r:t:l:" opt
do
	case $opt in
		r) REPO=$OPTARG ;;
		t) TAGNAME=$OPTARG ;;
		l) LOGFILE=$OPTARG ;;
		*) echo "USAGE $0 <-r repository> <-t tagname> <-l logdir>"; exit 1
	esac
done

if [ -z "${REPO}" -o -z "${TAGNAME}" -o -z "${LOGDIR}" ] ; then
	echo "USAGE $0 <-r repository> <-t tagname> <-l logdir>"; exit 1
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

REPONAME="$(basename $REPO)"
cd $REPO

LTAG=""

# list tags in ascending order by date and grab the first signed one
for t in $(git tag --sort=committerdate) ; do
	git tag -v $t 2>/dev/null && LTAG="$t"
done

# dump last tag
if [ ! -z "$LTAG" ] ; then
	echo "/* GITLOG PREVIOUS TAG $REPONAME $LTAG $LOGFILE */" >> $LOGFILE
	echo							>> $LOGFILE
	git show --quiet $LTAG					>> $LOGFILE
	git tag -v $LTAG					>> $LOGFILE
	echo							>> $LOGFILE
fi
echo "/* GITLOG COMMITS $REPONAME $TAGNAME $LOGFILE */"		>> $LOGFILE
echo								>> $LOGFILE

# dump history
if [ -z "$LTAG" ] ; then
	echo "no signed tag present... dumping full log"
	git log --reverse --full-history --pretty --shortstat			>> $LOGFILE
else
	git log "$LTAG"..HEAD --reverse --full-history --pretty --shortstat	>> $LOGFILE
fi

# sign tag
git tag -s $TAGNAME -m "" 2>/dev/null || exit 1
#if [ $? -ne 0 ] ; then
#
#fi

echo							>> $LOGFILE
echo "/* GITLOG TAG $REPONAME $LTAG $LOGFILE */"	>> $LOGFILE
echo							>> $LOGFILE
# dump current tag
git show --quiet $TAGNAME				>> $LOGFILE
git tag -v $TAGNAME					>> $LOGFILE

echo							>> $LOGFILE
echo "/* GITLOG PUBLIC KEY */"				>> $LOGFILE
echo							>> $LOGFILE
# dump active gpg key
gpg --no-emit-version -a --export			>> $LOGFILE

cd -
