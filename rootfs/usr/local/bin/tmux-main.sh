#!/bin/sh
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

tmux new-session -A -E -s main /bin/zsh
