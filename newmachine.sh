#!/bin/bash

# attempt to grab ssh keys from core.tnnt



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

# Assume debian/ubuntu and install tmux-next
sudo apt-get install sudo git vim

if [[ "$OS" == "Debian GNU/Linux" ]]; then
	if [[ "$VERSION" == "8 (jessie)" ]]; then
		sudo apt-get install -t jessie-backports tmux
	elif [[ "$VERSION" == "9 (stretch)" ]]; then
		sudo apt-get install -t stretch-backports tmux
	fi
fi
if [[ "$OS" == "Ubuntu" ]]; then 
	sudo apt-get update -yqqu
	sudo add-apt-repository -yu ppa:pi-rho/dev
	sudo apt-get update -yqqu
	sudo apt-get install -yqqu python-software-properties software-properties-common
	sudo apt-get install -yqq tmux-next
fi

#Setup git
git config --global user.name "VibroAxe"
git config --global user.email "vibs@macrolevel.co.uk"
git config --global branch.*branch-name*.rebase true # Force existing branches to use rebase.
git config --global push.default current

#Clone dotfiles and install
git clone git@gitlab.com:VibroAxe/dotfiles.git ~/.config

#Clone scripts and install
git clone git@gitlab.com:VibroAxe/scripts.git ~/scripts

#Finally install and link the dotfiles 
~/.config/installdots.sh

