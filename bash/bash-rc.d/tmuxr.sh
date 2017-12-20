#!/bin/bash
tmuxr() {

	#if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
if [[ -v TMUX ]]; then
	#tmux rename-window "$(echo $* | cut -d . -f 1)"
	tmux rename-window "tmux: $(echo $@ | rev | cut -d ' ' -f1 | rev | cut -d . -f 1)"
	 { ( sleep 1 && tmux source-file ~/.config/tmux/tmux-enterremote.conf) & disown; } 2>/dev/null && command ssh "$@" -t -C "tmux a || tmux"
	tmux source-file ~/.config/tmux/tmux-leaveremote-commands.conf
	tmux set-window-option automatic-rename "on" 1>/dev/null
else
	command ssh "$@" -t -C "tmux a || tmux"
fi

}

ssh-tmux() {
	tmuxr $@
}

tmux-ssh() {
	tmuxr $@
}
