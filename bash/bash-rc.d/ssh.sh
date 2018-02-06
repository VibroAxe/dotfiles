#!/bin/bash

SSH_AUTH_SOCK_FILE=~/.ssh/sock/${HOSTNAME}_ssh_auth_sock;
if [ ! -d ~/.ssh/sock ]; then
	mkdir -p ~/.ssh/sock
fi

# ssh-agent configuration
if [ -z ${SSH_AUTH_SOCK+x} ]; then
	#SSH_AUTH_SOCK is unset
	export SSH_AUTH_SOCK=$SSH_AUTH_SOCK_FILE;
	if [ -z "$(pgrep ssh-agent)" ]; then
		#cleanup sockets
		#rm -rf /tmp/ssh-* 2> /dev/null
		eval $(ssh-agent -a $SSH_AUTH_SOCK -s) > /dev/null
	else
		export SSH_AGENT_PID=$(pgrep ssh-agent)
		#export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.$SSH_AGENT_PID)
	fi
else
	#Using existing SSH_AUTH_SOCK (probably from ssh)
	echo $SSH_AUTH_SOCK_FILE
	if [ "$SSH_AUTH_SOCK" != "$SSH_AUTH_SOCK_FILE" ]; then
		if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
		    ln -sf "$SSH_AUTH_SOCK" $SSH_AUTH_SOCK_FILE;
		fi
		export SSH_AUTH_SOCK=$SSH_AUTH_SOCK_FILE;
	fi
fi

ssh() {

	#if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
	if [[ -v TMUX ]]; then
		#tmux rename-window "$(echo $* | cut -d . -f 1)"
		tmux rename-window "ssh: $(echo $* | rev | cut -d ' ' -f1 | rev | cut -d . -f 1)"
		ssh_connect "$@"
		tmux set-window-option automatic-rename "on" 1>/dev/null
	else
		ssh_connect "$@"
	fi

}

ssh_connect() {
	load
	command ssh -A "$@"
}

load() {
	if [ "$(ssh-add -l)" == "The agent has no identities." ]; then
   		ssh-add
		usb_keys=`find /mnt/ -maxdepth 3 -name "id_[a-z,0-9]*" -not -name "id_*.pub"`
		ssh-add $usb_keys
	fi
}
