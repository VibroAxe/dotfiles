#!/bin/bash

# attempt to grab ssh keys from core.tnnt
echo "Attempting to grab ssh keys from tnnt"
scp -r vibs@core.tnnt.co.uk:.ssh/ ~/
rm ~/.ssh/authorized_keys

# Assume debian/ubuntu
sudo apt-get install sudo tmux git vim


#Setup git
git config --global user.name "VibroAxe"
git config --global user.email "vibs@macrolevel.co.uk"
git config --global branch.*branch-name*.rebase true # Force existing branches to use rebase.

#Clone dotfiles and install
git clone git@github.com:VibroAxe/dotfiles.git ~/.dotfiles
.dotfiles/installdots.sh

#Clone scripts and install
git clone git@github.com:VibroAxe/scripts.git ~/scripts

