#!/usr/bin/env bash

name=${PWD//\//_}
export PROJECT_DIR="$PWD"
(zellij attach $name || zellij -s $name) && zellij delete-session $name || true
