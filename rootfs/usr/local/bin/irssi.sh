#!/bin/sh

export AWL_NOTITLE=1
export AWL_SSIZE=$(/bin/stty size)
#T3=$(pgrep -u $USER -x irssi)
T3=$(tmux list-sessions -F '#{session_name}' | grep irc)

#ctrl-b
#1..N switch window
#c  create window
#w  list windows
#n  next window
#p  previous window
#f  find window
#,  name window
#&  kill window
#%  vertical split
#"  horizontal split
#o  swap panes
#q  show pane numbers
#x  kill pane
#+  break pane into window (e.g. to select text by mouse to copy)
#-  restore pane from window
#⍽  space - toggle between layouts
#<prefix> q (Show pane numbers, when the numbers show up type the key to goto that pane)
#<prefix> { (Move the current pane left)
#<prefix> } (Move the current pane right)
#<prefix> z toggle pane zoom

irssi_nickpane() {
	tmux setw main-pane-width $(( $(tput cols) - 21));
	tmux splitw -v "cat ~/.irssi/nicklistfifo";
	tmux selectl main-vertical;
	tmux selectw -t irssi;
	tmux selectp -t 0;
}

irssi_repair() {
	tmux selectw -t irssi
	(( $(tmux lsp | wc -l) > 1 )) && tmux killp -a -t 0
#	irssi_nickpane
}

if [ -z "$T3" ]; then
	tmux new-session -E -d -s irc tail -f /var/log/strace.log
	tmux new-window -t irc -n irssi sg wanout -c \
	"systrace -d /usr/local/etc/systrace -ia /usr/bin/irssi -- --config ~/.config/irssi/config"
#    irssi_nickpane
else
    tmux attach-session -d -t irc;
#    irssi_repair
fi

exit 0
