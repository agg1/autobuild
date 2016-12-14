export TERM=xterm-256color
export EDITOR=/usr/bin/vi
export PINENTRY_USER_DATA="USE_CURSES=1"
GPG_TTY=$(tty)
export GPG_TTY
/usr/bin/gpg-agent --homedir ~/.gnupg --use-standard-socket --daemon --pinentry-program /usr/bin/pinentry-curses 2>/dev/null || true

xrdb ~/.Xdefaults
rehash
ttyctl -f
setopt nohup
alias ll='ls -Flisah --color=auto'
alias ls='ls --color=auto'

# vi mode
#bindkey -v
# emacs mode
bindkey -e
#
bindkey "^[[3~"  delete-char
bindkey "^[3;5~" delete-char
bindkey '^D' delete-char-or-list
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[5~" up-line-or-history       # [PageUp] - Up a line of history
bindkey "^[[6~" down-line-or-history     # [PageDown] - Down a line of history
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

autoload -U colors && colors
autoload -Uz compinit promptinit
compinit
promptinit

prompt bart green cyan grey

eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
#zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select

setopt COMPLETE_ALIASES
#setopt correctall
setopt autocd
setopt extendedglob

autoload -Uz run-help
unalias run-help
alias help=run-help
#autoload -Uz run-help-git
#autoload -Uz run-help-ip
#autoload -Uz run-help-openssl
#autoload -Uz run-help-p4
#autoload -Uz run-help-sudo
#autoload -Uz run-help-svk
#autoload -Uz run-help-svn

autoload -Uz add-zsh-hook
function xterm_title_precmd () {
	print -Pn '\e]2;%n@%m %1~\a'
}
function xterm_title_preexec () {
	print -Pn '\e]2;%n@%m %1~ %# '
	print -n "${(q)1}\a"
}
if [[ "$TERM" == (screen*|xterm*|rxvt*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

#autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search
#
#[[ -n "${key[Up]}"   ]] && bindkey "${key[Up]}"   up-line-or-beginning-search
#[[ -n "${key[Down]}" ]] && bindkey "${key[Down]}" down-line-or-beginning-search

#DIRSTACKFILE="$HOME/.cache/zsh/dirs"
#if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
#  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
#  [[ -d $dirstack[1] ]] && cd $dirstack[1]
#fi
#chpwd() {
#  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
#}
#DIRSTACKSIZE=20
#setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
## Remove duplicate entries
#setopt PUSHD_IGNORE_DUPS
## This reverts the +/- operators.
#setopt PUSHD_MINUS

#$ lesskey -o .less -
#
##command
#\eOF goto-end
#\eOH goto-line
