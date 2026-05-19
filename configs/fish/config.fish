# [ -f "~/.bashrc" ] && source "~/.bashrc"
source ~/.env
# source /usr/share/cachyos-fish-config/cachyos-config.fish

bind ctrl-q "clear_all; fishreload"
bind alt-shift-l "clear_all;"
alias ffkill='ps -ef | fzf --header "Kill Process" --bind "del:execute(echo {} | awk \"{print \$2}\" | xargs kill -9)+reload(ps -ef)"'
alias cli='bash ./cli.sh'
# alias restart_desktop='sh ~/.nix-home/restart'

set -g theme_display_date no
set -g theme_color_scheme dracula

fzf --fish | source

function ff_cd
	cd (ff --cd)
	commandline -f repaint
end

function tere_action
	set -l rs (kitty_yazi)
	if test $status -ne 0
		commandline -f repaint
		return
	end
	commandline -a " $rs"
	commandline -f end-of-line
end

function clear_all
	printf "\033c"
	commandline -f repaint
end

function fish_greeting
end

bind alt-n tere_action
bind alt-p ff_cd
