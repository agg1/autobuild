# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

# Put your fun stuff here.
export LANG="en_US.utf-8"
export LC_COLLATE="en_US.utf-8"
export LC_CTYPE="en_US.utf-8"
export LC_MESSAGES="en_US.utf-8"
export LC_MONETARY="en_US.utf-8"
export LC_NUMERIC="en_US.utf-8"
export LC_TIME="en_US.utf-8"
export LC_ALL=

export EDITOR=/usr/bin/vi

set +o history
umask 0007
if [ -z "$RUNX" -a ! -e ${HOME}/.nox ] ; then
	export RUNX=1
	exec /usr/local/bin/runx.sh
fi
