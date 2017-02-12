#!/bin/sh

CONFIG=/path/to/tidy_options.conf
CONVDIR=$1
AUTHOR=$2

if [ -z "${CONVDIR}" -o ! -e "${CONVDIR}" ] ; then
	echo "dir error" ; exit 1
fi

if [ ! -x /usr/bin/soffice ] ; then
	echo "libreoffice is missing" ; exit 1
fi

#if [ ! -x /usr/bin/tidy ] ; then
#	echo "tidy is missing" ; exit 1
#fi

#for F in `find $1 -type f -name "*.doc" -or -name "*.odt"`
find $1 -type f -name '*.odt' -print0 | while IFS= read -r -d '' F
do
	echo $F
	basename=$(basename "$F")
	filename=$(basename "$basename" .odt)
	dirname=$(dirname "$F")
	/usr/bin/soffice --headless --convert-to html --outdir $dirname "$F"
	/usr/bin/soffice --headless --convert-to pdf --outdir $dirname "$F"
	#/usr/bin/tidy -config /usr/local/etc/convert-odt2html.conf -o "${dirname}/${filename}.xhtml" "${dirname}/${filename}.html"
	#mv "${dirname}/${filename}.xhtml" "${dirname}/${filename}.html"
	#rm -f ${dirname}/${filename}.xhtml
	cat "${dirname}/${filename}.html" | sed 's/<title>/<!-- [[!meta title=\"/' | sed 's/<\/title>/\"]] -->/' > "${dirname}/${filename}.html.tmp"
	mv "${dirname}/${filename}.html.tmp" "${dirname}/${filename}.html"
	if [ ! -z "${AUTHOR}" ] ;then
		echo "<!-- [[!meta author=\"${AUTHOR}\"]] -->" >> "${dirname}/${filename}.html"
	fi
done
