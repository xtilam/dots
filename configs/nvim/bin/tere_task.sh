#/usr/bin/env bash

file=$(kitty_yazi -d "$1" -t "$2")
if [[ -n "$file" ]]; then
  nvim-lua --defer 10 -- "hot.action_open(v[1])" -- -s $file
fi
