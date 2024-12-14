# $1 = input url

set -euxo pipefail

yt-dlp --extract-audio --audio-format wav --audio-quality 10 -o "$HOME/Desktop/samples/%(title)s.%(ext)s" "$1"
