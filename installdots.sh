#!/bin/bash

function git_clone_or_pull() {
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
		echo Updating $targetdir
		pushd $targetdir
		git pull
		popd
	else
		echo Cloning $repo into $targetdir
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
		$INTERACTIVE && read -p "$t already exists, happy to DELETE and overwrite? [Yn]" choice
		choice=${choice:-y}
		choice=`echo "$choice" | tr '[:upper:]' '[:lower:]'`
		if [[ $choice == "y" ]]; then
  			mv $t $t.bak;
		else
			echo "Not creating link"
			return;
		fi
	fi
	if [ -d $t ]; then
		#if directory delete recursively
		$INTERACTIVE && read -p "$t already exists, happy to RECURSIVELY DELETE and overwrite? [Yn]" choice
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

if [[ "$USER" != "codespace" ]]; then 
	INTERACTIVE=false
else
	INTERACTIVE=true
fi

cd ~

# Fix any regressions
[[ -f ~/.config/bash/bashrc.d/local ]] && echo "Moving bashrc.d/local to new home" && mv ~/.config/bash/bashrc.d/local ~/.config/bash/local

#Bash files
update_link ~/.config/bash/profile ~/.profile
update_link ~/.config/bash/dir_colors ~/.dir_colors
update_link ~/.config/bash/bashrc ~/.bashrc


git_clone_or_pull https://github.com/nojhan/liquidprompt.git ~/.config/liquidprompt/liquidprompt

#Dotvim
update_link ~/.config/vim ~/.vim
update_link ~/.config/vim/vimrc ~/.vimrc
git_clone_or_pull http://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
tmux new-session -d -s vundle 'vim +PluginClean +PluginInstall +qall'

#Tmux
update_link ~/.config/tmuxp ~/.tmuxp
update_link ~/.config/tmux/tmux.conf ~/.tmux.conf

#ssh
#Check .ssh exists
mkdir -p ~/.ssh
#override ssh config checkout
chmod 600 ~/.config/ssh/config
[ -f ~/.config/ssh/config.local ] && chmod 600 ~/.config/ssh/config.local
chmod 600 ~/.config/ssh/config.d/*
#link files
#mv to socket files if they exist
update_link ~/.config/ssh/config.d ~/.ssh/config.d
update_link ~/.config/ssh/config ~/.ssh/config

