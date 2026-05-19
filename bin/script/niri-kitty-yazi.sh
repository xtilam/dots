#!/usr/bin/env bash
kitten quick-access-terminal --instance-group niri-yazi -c ~/.config/kitty/niri-yazi-terminal.conf --detach bash -c 'file=$(yazi --chooser-file=/dev/stdout); [[ -n "$file" ]] &&  wl-copy "$file"; kitty @ close-window'
