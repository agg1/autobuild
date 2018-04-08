#!/bin/bash - 
version=4.15.15
if [ `echo $version | tr -cd '.' | wc -c` == 2 ]; then main=`echo ${version%.*}`; else main=$version; fi 
url=https://linux-libre.fsfla.org/pub/linux-libre/releases/

if [ ! -f deblob-$main ] ; then
	sg portage -c "wget $url$version-gnu/deblob-$main"
	sg portage -c "wget $url$version-gnu/deblob-$main.sign"
	sg portage -c "wget $url$version-gnu/deblob-check"
	sg portage -c "wget $url$version-gnu/deblob-check.sign"
fi

#sg wanout "gpg --keyserver keys.gnupg.net --recv-key BCB7CF877E7D47A7"
#gpg --verify deblob-$main.sign deblob-$main
#gpg --verify deblob-check.sign deblob-check

chmod 744 deblob-$main deblob-check

PYTHON="python2.7" ./deblob-$main 2>&1 | tee deblob-${main}.log
