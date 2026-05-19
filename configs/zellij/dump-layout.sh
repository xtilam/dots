#!/usr/bin/env bash

script_dir=$(dirname "$(readlink -f "$0")")
layoutname="$1"

zellij setup --dump-layout $layoutname > "$script_dir/layouts/$layoutname.kdl"
zellij setup --dump-swap-layout $layoutname > "$script_dir/layouts/$layoutname.swap.kdl"

