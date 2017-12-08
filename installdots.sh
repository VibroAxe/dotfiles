#!/bin/bash

#Bash files
cd ~
rm ~/.profile
rm ~/.bashrc
rm ~/.dir_colors
ln -s ~/.config/bash/profile ~/.profile
ln -s ~/.config/bash/dir_colors ~/.dir_colors
ln -s ~/.config/bash/bashrc ~/.bashrc

#Dotvim
cd ~
rm ~/.vimrc
rm -r ~/.vim
ln -s ~/.config/vim ~/.vim
ln -s ~/.config/vim/vimrc ~/.vimrc
git clone http://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

#Tmux
cd ~
rm ~/.tmux.conf
ln -s ~/.config/tmux/tmux.conf ~/.tmux.conf

#ssh
ln -s ~/.config/ssh/config ~/.ssh/config
