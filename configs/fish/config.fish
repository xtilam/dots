function fish_greeting
end

bind ctrl-q "clear_all; fishreload"
bind alt-shift-l "clear_all;"
alias ffkill='ps -ef | fzf --header "Kill Process" --bind "del:execute(echo {} | awk \"{print \$2}\" | xargs kill -9)+reload(ps -ef)"'
alias cli='bash ./cli'
alias restart_desktop='sh ~/.nix-home/restart'
bind alt-n "tere yazi; commandline -f repaint"
set -g theme_display_date no
set -g theme_color_scheme dracula

fzf --fish | source

function clear_all
	printf "\033c"
	commandline -f repaint
end
