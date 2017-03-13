# dotfiles - The GIT repo for all my dotfiles
My dotvim folder

## Steps to fun

git clone git@github.com:VibroAxe/dotfiles.git ~/.dotfiles
~/.dotfiles/installdots.sh

## Dependencies
These dotfiles probably expect to have the scripts repo from VibroAxe/scripts.git installed too!

## Editing
If creating a new dotfile, don't forget to add the ln -s into ~/.dotfiles/installdots.sh

## dotvim
Losely based on initial work from https://github.com/leepa/dotvim

Steps to fun...

1. Clone to .vim and symlink
 git clone git@github.com:VibroAxe/dotvim.git ~/.vim
 ln -s ~/.vim/vimrc ~/.vimrc

2. Install Vundle

git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

3. Run vim with PluginInstall

vim +PluginInstall +qall

