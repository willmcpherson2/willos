set -euxo pipefail

qmk flash -e CONVERT_TO=blok /etc/nixos/dot/willkbd.json
