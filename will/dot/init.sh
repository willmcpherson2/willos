stty -ixon

set enable-bracketed-paste on

alias l="ls -Alh"

PS1='\n\[\e[94;1m\]\W\[\e[0m\] \[\e[91;1m\]$?\[\e[0m\] \[\e[95;1m\]\t\[\e[0m\] \[\e[92;1m\]\\$\[\e[0m\] '

# Emacs libvterm integration

vterm_printf() {
    printf "\e]%s\e\\" "$1"
}

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}

PS1=$PS1'\[$(vterm_prompt_end)\]'
