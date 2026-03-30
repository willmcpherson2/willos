# $1 = audio file name

set -euxo pipefail

celluloid --mpv-lavfi-complex="[aid1]asplit[ao][v];[v]showspectrum=s=1280x720:mode=combined:slide=scroll:fscale=log:overlap=0.1[vo]" "$1"
