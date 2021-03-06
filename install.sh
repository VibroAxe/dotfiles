#!/bin/bash

if [ "$BASH_VERSION" = '' ]; then
	#This file doesn't work with dash, make sure we are running in bash as per the shebang
	bash $0
	return $?
fi

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

# If we aren't checked out to ~/.config then create some links
if [[ ! "$(readlink -f $0)" == "$(readlink -f ~/.config)"* ]]; then
	confmove=0
	if [ -d ~/.config ]; then
		echo "Backing up existing .config"
		confmove=1
		mv ~/.config ~/.config2
	fi
	ln -s dotfiles ~/.config
	if [ $confmove ]; then
		echo "Importing legacy .config"
		mv ~/.config2/* ~/.config/
		rmdir ~/.config2
	fi
fi

# Assume debian/ubuntu and install tmux-next
sudo apt-get install -y sudo vim

if [[ "$OS" == "Debian GNU/Linux" ]]; then
	if [[ "$VERSION" == "8 (jessie)" ]]; then
		sudo apt-get install -y -t jessie-backports tmux
	elif [[ "$VERSION" == "9 (stretch)" ]]; then
		sudo apt-get install -y -t stretch-backports tmux
	fi
fi
if [[ "$OS" == "Ubuntu" ]]; then 
	if [[ "$VERSION" == "xenial/xerus" ]]; then
		sudo apt-get update -yqqu
		sudo add-apt-repository -yu ppa:pi-rho/dev
		sudo apt-get update -yqqu
		sudo apt-get install -yqqu python-software-properties software-properties-common
		sudo apt-get install -yqq tmux-next
	else
		sudo apt-get install -y tmux
	fi
fi

if grep -qE "(microsoft)" /proc/version &> /dev/null ; then
	OS=WSL
	VER=2
	#WSL2, get pageant
	mkdir -P ~/.ssh
	wget https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/download/v1.2.0/wsl2-ssh-pageant.exe -O ~/.ssh/wsl2-ssh-pageant.exe
	chmod +x ~/.ssh/wsl2-ssh-pageant.exe
fi


#Setup git
git config --global user.name "VibroAxe"
git config --global user.email "vibs@macrolevel.co.uk"
git config --global pull.rebase true # Force existing branches to use rebase.
git config --global push.default current

#Clone scripts and install
git clone git@gitlab.com:VibroAxe/scripts.git ~/scripts

#Finally install and link the dotfiles 
~/.config/installdots.sh

