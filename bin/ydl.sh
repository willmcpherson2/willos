#!/usr/bin/env bash

# $1 = input url
# $2 = output filename

set -euxo pipefail

youtube-dl -o "$2" -f 'bestaudio[ext=m4a]' "$1"
ffmpeg -i "$2" ~/Desktop/samples/"$2".wav
rm "$2"
