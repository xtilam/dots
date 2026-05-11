#/usr/bin/env bash

file=$(kitty_yazi "$2" "$1")
if [[ -n "$file" ]]; then
  nvim-lua --defer 10 -- "hot.action_open(v[1])" -- -s $file
fi
