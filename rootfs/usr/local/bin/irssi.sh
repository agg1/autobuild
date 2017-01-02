#!/bin/sh

export AWL_NOTITLE=1
export AWL_SSIZE=$(/bin/stty size)
#T3=$(pgrep -u $USER -x irssi)
T3=$(tmux list-sessions -F '#{session_name}' | grep irc)

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
	tmux new-session -E -d -s irc
	sleep 1
	tmux new-window -t irc -n irssi sg wanout -c \
	"systrace -d /usr/local/etc/systrace -ia /usr/bin/irssi -- --config ~/.config/irssi/config"
#    irssi_nickpane
else
    tmux attach-session -d -t irc;
#    irssi_repair
fi

exit 0
