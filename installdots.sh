#!/bin/bash

function git_clone_or_update() {
	repo=$1
	targetdir=$2
	if [ $# -lt 1 ]; then
		echo ERROR: No Repo provided
	fi
	if [ $# -lt 2 ]; then
		targetdir=$(basename $1)
		targetdir=$(targetdir%.*)
		echo targetdir
	fi
	if [ -d $targetdir ]; then
		pushd $targetdir
		git pull
		popd
	else
		git clone $repo $targetdir
	fi
}

function update_link() {
	s=$1
	t=$2
	if [ -L $t ]; then
		#Attempt unlink first
		unlink $t;
	fi
	if [ -f $t ]; then
		#if file delete
		read -p "$t already exists, happy to DELETE and overwrite? [Yn]" choice
		choice=${choice:-y}
		choice=`echo "$choice" | tr '[:upper:]' '[:lower:]'`
		if [[ $choice == "y" ]]; then
			rm $t;
		else
			echo "Not creating link"
			return;
		fi
	fi
	if [ -d $t ]; then
		#if directory delete recursively
		read -p "$t already exists, happy to RECURSIVELY DELETE and overwrite? [Yn]" choice
		choice=${choice:-y}
		choice=`echo "$choice" | tr '[:upper:]' '[:lower:]'`
		if [[ $choice == "y" ]]; then
			rm -r $t;
		else
			echo "Not creating link"
			return;
		fi
	fi
	ln -s $s $t
}

cd ~

#Bash files
update_link ~/.config/bash/profile ~/.profile
update_link ~/.config/bash/dir_colors ~/.dir_colors
update_link ~/.config/bash/bashrc ~/.bashrc

#liquid prompt
git_clone_or_update https://github.com/nojhan/liquidprompt.git ~/.config/liquidprompt/liquidprompt

#Dotvim
update_link ~/.config/vim ~/.vim
update_link ~/.config/vim/vimrc ~/.vimrc
git_clone_or_update http://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

#Tmux
update_link ~/.config/tmux/tmux.conf ~/.tmux.conf

#ssh
#override ssh config checkout
chmod 600 ~/.config/ssh/config
#link files
update_link ~/.config/ssh/config ~/.ssh/config


