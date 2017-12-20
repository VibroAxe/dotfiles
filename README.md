# dotfiles - The GIT repo for all my dotfiles
My .Config folder

## Steps to fun

* git clone git@github.com:VibroAxe/dotfiles.git ~/.config
* ~/.config/installdots.sh

## Dependencies
* vim
* tmux(>2.0) / tmux-next 
* bash
* liquidprompt
* Vundle (vim plugin manager)
* These dotfiles probably expect to have the scripts repo from VibroAxe/scripts.git installed too!

## Editing
If creating a new dotfile, don't forget to add the ln -s into ~/.config/installdots.sh

## Extra info

### bash
* ssh overridden with function to provide hostname information to tmux if available
* tmux overrride to tmux-next if exists
* tmuxr to ssh remote host and launch remote ssh with delegated control (see tmux)
* git_prompt (to be updated to liquidprompt soon)

### tmux
Functionality for nested tmuxs (depth of one)
* Shift-up moves into remote session
* Shift-down moves back to local session


### dotvim
Losely based on initial work from https://github.com/leepa/dotvim

