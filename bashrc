stty -ixon

HISTSIZE=
HISTFILESIZE=
HISTCONTROL=ignoredups

set enable-bracketed-paste on

alias diff="git diff --no-index"
alias grep="grep --color=auto"

export EDITOR="nvim"
export PAGER="nvimpager"

export PATH="/etc/nixos/bin:$PATH"
