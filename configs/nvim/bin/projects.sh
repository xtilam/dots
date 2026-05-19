#!/usr/bin/env bash
export SHELL=bash
dir=$(ff --cd) && nvim-lua --defer 10 -- "hot.action_open(v[1])" -- -s "$dir" || true
