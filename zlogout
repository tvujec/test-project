#! /bin/zsh
#


bzip2 -c $HOME/.zhist > $DOTFILES/zhist-$(whoami)@$(hostname).bz2
