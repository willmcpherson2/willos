{ pkgs ? import <nixpkgs> { } }:

let willos = ./.;
in
pkgs.mkShell {
  shellHook = ''
    set -euxo pipefail

    read -p "disk = " DISK
    read -sp "password = " PASSWORD

    parted "$DISK" -- mklabel gpt
    parted "$DISK" -- mkpart primary 512MB -8GB
    parted "$DISK" -- mkpart primary linux-swap -8GB 100%
    parted "$DISK" -- mkpart ESP fat32 1MB 512MB
    parted "$DISK" -- set 3 esp on
    mkfs.ext4 -L nixos "$DISK"p1
    mkswap -L swap "$DISK"p2
    mkfs.fat -F 32 -n boot "$DISK"p3
    mount /dev/disk/by-label/nixos /mnt
    mkdir -p /mnt/boot
    for _ in {1..3}
    do
      mount /dev/disk/by-label/boot /mnt/boot && break || sleep 1
    done
    swapon "$DISK"p2

    nixos-generate-config --root /mnt
    cp -r ${willos}/* /mnt/etc/nixos

    mkpasswd --method=sha-512 "$PASSWORD" > /mnt/etc/passwordFile-will
    chmod 600 /mnt/etc/passwordFile-will

    nixos-install --no-root-passwd
  '';
}
