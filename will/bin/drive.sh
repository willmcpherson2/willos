# $1 = "push" or "pull"
#
# e.g.
# drive push
# drive pull
#
# https://rclone.org/commands/rclone_sync/

set -euxo pipefail

declare -a folders=(
    "doc"
    "photos"
    "masters"
    "samples"
    "bitwig"
    "blender"
    "kdenlive"
    "scratch"
)

if [ "$1" == "push" ]; then
    for folder in ${folders[@]}; do
        rclone sync --interactive --create-empty-src-dirs "$folder" "drive-willmcpherson2:$folder"
    done
elif [ "$1" == "pull" ]; then
    for folder in ${folders[@]}; do
        rclone sync --interactive --create-empty-src-dirs "drive-willmcpherson2:$folder" "$folder"
    done
fi
