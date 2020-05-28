#!/bin/bash

create_gpg_agent() {
	if grep -qE "(microsoft)" /proc/version &> /dev/null ; then
		export GPG_AGENT_TYPE=wsl2
		ss -a | grep -q $GPG_AGENT_SOCK
		if [ $? -ne 0 ]; then
			if [ -S $GPG_AGENT_SOCK_FILE ] || [ -L $GPG_AGENT_SOCK_FILE ] || [ -f $GPG_AGENT_SOCK_FILE ]; then
				rm $GPG_AGENT_SOCK_FILE
			fi
			rm -f $GPG_AGENT_SOCK
			(setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:$HOME/.ssh/wsl2-gpg-pageant.exe --gpg S.gpg-agent >/dev/null 2>&1 &)
		fi
	fi
}

export GPG_AGENT_SOCK_FILE=~/.gnupg/sock/${HOSTNAME}_GPG_AGENT_SOCK;
if [ ! -d ~/.gnupg/sock ]; then
	mkdir -p ~/.gnupg/sock
fi

# gpg-agent configuration
if [ -z ${GPG_AGENT_SOCK+x} ]; then
	#GPG_AGENT_SOCK is unset
	export GPG_AGENT_SOCK=$GPG_AGENT_SOCK_FILE;
	create_agent
else
	#Using existing GPG_AGENT_SOCK (probably from gpg)
	echo $GPG_AGENT_SOCK_FILE
	if [ "$GPG_AGENT_SOCK" != "$GPG_AGENT_SOCK_FILE" ]; then
		if [[ -S "$GPG_AGENT_SOCK" && ! -h "$GPG_AGENT_SOCK" ]]; then
		    ln -sf "$GPG_AGENT_SOCK" $GPG_AGENT_SOCK_FILE;
		fi
		export GPG_AGENT_SOCK=$GPG_AGENT_SOCK_FILE;
	fi
fi


gpg-agent() {
	create_agent
	command gpg-agent "$@"
}

load-gpg-keys() {
	agent_response=`gpg-add -l 2>&1`;
	if [ $? -eq 2 ] || [[ "$agent_response" == "Error connecting to agent: No such file or directory" ]]; then
		create_agent
		agent_response=`gpg-add -l`;
	fi
	if [[ "$agent_response" == "The agent has no identities." ]]; then
		if [[ "$gpg_AGENT_TYPE" == "opengpg" ]]; then
			#if weasel we can't add gpg keys?
   			gpg-add
			usb_keys=`find /mnt/ -maxdepth 3 -name "id_[a-z,0-9]*" -not -name "id_*.pub"`
			gpg-add $usb_keys
		fi
	fi
}
