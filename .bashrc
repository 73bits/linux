case $- in
    *i*) ;;
      *) return;;
esac

shopt -s autocd
shopt -s histappend
shopt -s checkwinsize
bind 'set bell-style none'

HISTSIZE=
HISTFILESIZE=
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%d-%m %T "
HISTIGNORE="ll:ls:ls -l:ls -lA:pwd:clear :.."

alias ls='ls --group-directories-first --color=always'
alias ll='ls -lA'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias du='du -ch'
alias ip='ip -c'
alias shred='shred -vzn3'
alias grep='grep --color=auto'

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

PS1='\[\e[0;1;91m\][\[\e[0;1;38;5;159m\]\u\[\e[0;1;91m\]@\[\e[0;1;38;5;154m\]\H \[\e[0;1;38;5;129m\]\W \[\e[0;1;91m\]] \[\e[0;1;97m\]\$ \[\e[0m\]'
