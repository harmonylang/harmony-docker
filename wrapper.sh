#!/bin/sh

if [ -f "$HOME/.charm.exe" ]; then
  touch "$HOME/.charm.exe"
  ./harmony "$@"
else
  printf "Error: Cannot find charm.exe in the image"
fi
