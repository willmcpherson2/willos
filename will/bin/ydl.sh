# $1 = input url

set -euxo pipefail

yt-dlp --extract-audio -o "~/Desktop/samples/%(title)s.%(ext)s" "$1"
