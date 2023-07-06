#!/bin/bash

git-connect() {
	#echo "Testing git agent"
	#git $@
	#return
	echo $@ | egrep -h "clone|fetch|pull|push"
	if [ $? -eq 0 ]; then
		SSH=1
	else
		SSH=0
	fi
	if [ $SSH -eq 1 ]; then
	#	echo "Loading keys"
		load-ssh-keys
	fi
	command git "$@"
}

alias git="git-connect"

