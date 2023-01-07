set -euxo pipefail

qmk flash -c -e CONVERT_TO=blok /etc/nixos/dot/willkbd.json
