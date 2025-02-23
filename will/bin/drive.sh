# $1 = "push" or "pull"
#
# e.g.
# drive push
# drive pull
#
# Auth
# - Run rclone config
# - Enter "drive-willmcpherson2" for name of config
# - Set backend to Google Drive
# - Get client ID and client secret from "OAuth 2.0 Client IDs" https://console.cloud.google.com/apis/credentials?project=drive-willmcpherson2
# - Enter client ID
# - Enter client secret
# - Select full access
# - Skip rest of steps
# - Browser should open for login

set -euxo pipefail

declare -a folders=(
    "doc"
    "photos"
    "masters"
    "bitwig"
)

if [ "$1" == "push" ]; then
    for folder in ${folders[@]}; do
        rclone sync --create-empty-src-dirs "$folder" "drive-willmcpherson2:$folder"
    done
elif [ "$1" == "pull" ]; then
    for folder in ${folders[@]}; do
        rclone sync --create-empty-src-dirs "drive-willmcpherson2:$folder" "$folder"
    done
fi
