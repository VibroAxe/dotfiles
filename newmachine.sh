#!/bin/bash

# attempt to grab ssh keys from core.tnnt
echo "Attempting to grab ssh keys from tnnt"
scp -r vibs@core.tnnt.co.uk:.ssh/ ~/
cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
rm ~/.ssh/known_hosts

# Assume debian/ubuntu and install tmux-next
sudo apt-get install sudo git vim
sudo apt-get update -yqqu
sudo add-apt-repository -yu ppa:pi-rho/dev
sudo apt-get update -yqqu
sudo apt-get install -yqqu python-software-properties software-properties-common
sudo apt-get install -yqq tmux-next

#Setup git
git config --global user.name "VibroAxe"
git config --global user.email "vibs@macrolevel.co.uk"
git config --global branch.*branch-name*.rebase true # Force existing branches to use rebase.
git config --global push.default simple

#Clone dotfiles and install
git clone git@github.com:VibroAxe/dotfiles.git ~/.dotfiles
.dotfiles/installdots.sh

#Clone scripts and install
git clone git@github.com:VibroAxe/scripts.git ~/scripts
