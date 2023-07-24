#!/bin/bash

if grep -qE "(microsoft)" /proc/version &> /dev/null ; then
	#WSL2
	#export GPG_AGENT_SOCK=$HOME/.gnupg/S.gpg-agent
	#ss -a | grep -q $GPG_AGENT_SOCK
	#if [ $? -ne 0 ]; then
	#	        rm -rf $GPG_AGENT_SOCK
	#			        (setsid nohup socat UNIX-LISTEN:$GPG_AGENT_SOCK,fork EXEC:"$HOME/.ssh/wsl2-ssh-pageant.exe --gpg S.gpg-agent" >/dev/null 2>&1 &)
	#fi
	alias gpg=gpg.exe
fi
