#
# ~/.bashrc
#

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

alias ls='ls -a --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# To ensure Neovim does not only use MYVIMRC instead of init.lua
export MYVIMRC="$HOME/.config/vim/vimrc"
export EDITOR="vim"
vim() {
	VIMINIT="source $MYVIMRC" command vim "$@"
}
export -f vim

export PATH="$PATH:~/git/scripts"
