# Run this script is run to init a new machine
# It is not run by VS/Github Codespaces

# Assume debian/ubuntu and install sudo/git
sudo apt-get install sudo git

# Clone dotfiles
git clone https://github.com/VibroAxe/dotfiles.git ~/.config

# Update push url to use ssh
cd ~/.config
git remote set-url origin --push git@github.com:VibroAxe/dotfiles.git

# And install
~/.config/install.sh

