#!/bin/sh

export AWL_NOTITLE=1
export AWL_SSIZE=$(/bin/stty size)
T3=$(pgrep -u $USER -x irssi)

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
#    irssi_nickpane
}

if [ -z "$T3" ]; then
    tmux new-session -E -d -s main tail -f /var/log/strace;
    #tmux new-session -E -d -s main tail;
    tmux new-window -t main -n irssi sg wanout -c "systrace -d /usr/local/etc/systrace -ia /usr/bin/irssi -- --config ~/.config/irssi/config";
#    irssi_nickpane
fi
    tmux attach-session -d -t main;
    irssi_repair
exit 0
