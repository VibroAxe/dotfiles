#!/bin/bash

create_agent() {
	if [ -S $SSH_AUTH_SOCK_FILE ] || [ -L $SSH_AUTH_SOCK_FILE ] || [ -f $SSH_AUTH_SOCK_FILE ]; then
		rm $SSH_AUTH_SOCK_FILE
	fi
	if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
		## WSL 1
		# Handle wsl weasel-pageant
		eval $(/opt/weasel-pageant/weasel-pageant -a $SSH_AUTH_SOCK -r) > /dev/null
		export SSH_AGENT_TYPE=weasel
	else
		if grep -qE "(microsoft)" /proc/version &> /dev/null ; then
			export SSH_AGENT_TYPE=wsl2
			ss -a | grep -q $SSH_AUTH_SOCK
			if [ $? -ne 0 ]; then
				rm -f $SSH_AUTH_SOCK
				(setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:$HOME/.ssh/wsl2-ssh-pageant.exe >/dev/null 2>&1 &)
			fi
		else
			export SSH_AGENT_TYPE=openssh
			eval $(ssh-agent -a $SSH_AUTH_SOCK -s) > /dev/null
		fi
	fi
}

export SSH_AUTH_SOCK_FILE=~/.ssh/sock/${HOSTNAME}_ssh_auth_sock;
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
		create_agent
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
	load-ssh-keys
	command ssh "$@"
}

load-ssh-keys() {
	agent_response=`ssh-add -l 2>&1`;
	if [ $? -eq 2 ] || [[ "$agent_response" == "Error connecting to agent: No such file or directory" ]]; then
		create_agent
		agent_response=`ssh-add -l`;
	fi
	if [[ "$agent_response" == "The agent has no identities." ]]; then
		if [[ "$SSH_AGENT_TYPE" == "openssh" ]]; then
			#if weasel we can't add ssh keys?
   			ssh-add
			usb_keys=`find /mnt/ -maxdepth 3 -name "id_[a-z,0-9]*" -not -name "id_*.pub"`
			ssh-add $usb_keys
		fi
	fi
}
