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

echo "Detected OS: $OS @ $VER"

# If we aren't checked out to ~/.config then create some links
if [[ ! "$(dirname $(readlink -f $0))" == "$(readlink -f ~/.config)"* ]]; then
	confmove=0
	if [ -d ~/.config ]; then
		echo "Backing up existing .config"
		confmove=1
		mv ~/.config ~/.config2
	fi
	ln -s $(dirname $(readlink -f $0)) ~/.config
	if [ $confmove ]; then
		echo "Importing legacy .config"
		mv ~/.config2/* ~/.config/
		rmdir ~/.config2
	fi
fi

# Assume debian/ubuntu and install tmux-next
sudo apt update
sudo apt-get install -y sudo vim python3-pip

if [[ "$OS" == "Debian GNU/Linux" ]]; then
	if [[ "$VERSION" == "8 (jessie)" ]]; then
		sudo apt-get install -y -t jessie-backports tmux
	elif [[ "$VERSION" == "9 (stretch)" ]]; then
		sudo apt-get install -y -t stretch-backports tmux
  	else
   		sudo apt install -y tmux
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
		sudo apt install -y tmux
	fi
fi

if grep -qE "(microsoft)" /proc/version &> /dev/null ; then
	OS=WSL
	VER=2
	#WSL2, get pageant
	mkdir -p ~/.ssh
	sudo apt install socat wslu vim-gtk3
	WINHOME=`wslpath "$(wslvar USERPROFILE)"`
	mkdir -p $WINHOME/bin
	wget https://github.com/BlackReloaded/wsl2-ssh-pageant/releases/download/v1.2.0/wsl2-ssh-pageant.exe -O $WINHOME/bin/wsl2-ssh-pageant.exe
	chmod +x $WINHOME/bin/wsl2-ssh-pageant.exe
	ln -s $WINHOME/bin/wsl2-ssh-pageant.exe ~/.ssh/
	alias gpg=gpg.exe
	git config --global gpg.program gpg.exe
fi

#liquid prompt
which acpi
if [ $? -eq 1 ]; then
	if [[ "$CODESPACES" != "true" ]]; then 
		read -p "Couldn't find acpi command, install? [Yn]" choice
		choice=${choice:-y}
		choice=`echo "$choice" | tr '[:upper:]' '[:lower:]'`
		if [[ $choice == "y" ]]; then
			sudo apt install acpi -y
		fi
  	fi
fi

pip install --user tmuxp

#Setup git
if [[ "$USER" != "codespace" ]]; then
	git config --global user.name "VibroAxe"
	git config --global user.email "vibs@macrolevel.co.uk"
	git config --global user.signingkey 870B0F17FCC20B51013482AD40B6BA8C883A7FF2
fi
git config --global pull.rebase true # Force existing branches to use rebase.
git config --global push.default current
# Force gpg signing, can be overridden with gpg commit --no-gpg-sign
git config --global commit.gpgsign true

gpg --import ~/.config/gpg/yubikey_stub.key

#Clone scripts and install
git clone https://github.com/VibroAxe/scripts.git ~/scripts
pushd ~/scripts
git remote set-url origin --push git@github.com:VibroAxe/scripts.git
popd

#Finally install and link the dotfiles 
echo Installing Dots
~/.config/installdots.sh
echo Done Installing Dots
echo Install complete
