#!/usr/bin/env bash

find ~/Desktop/github -mindepth 2 -maxdepth 2 -type d | rofi -dmenu -i | xargs -r -I{} "${EDITOR:-code}" {}