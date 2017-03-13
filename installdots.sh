#!/bin/bash

#Bash files
cd ~
ln -s ~/.dotfiles/bash/profile ~/.profile
ln -s ~/.dotfiles/bash/dir_colors ~/.dir_colors
ln -s ~/.dotfiles/bash/bashrc ~/.bashrc

#Dotvim
cd ~
ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
git clone http://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

#Tmux
cd ~
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
