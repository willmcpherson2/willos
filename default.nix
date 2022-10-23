{ pkgs ? import <nixpkgs> {} }:

let
  configuration = ./configuration.nix;
in
pkgs.mkShell {
  name = "willos";
  shellHook =
    ''
      set -euxo pipefail

      read -p "disk = " DISK

      parted "$DISK" -- mklabel gpt
      parted "$DISK" -- mkpart primary 512MB -8GB
      parted "$DISK" -- mkpart primary linux-swap -8GB 100%
      parted "$DISK" -- mkpart ESP fat32 1MB 512MB
      parted "$DISK" -- set 3 esp on
      mkfs.ext4 -L nixos "$DISK"1
      mkswap -L swap "$DISK"2
      mkfs.fat -F 32 -n boot "$DISK"3
      mount /dev/disk/by-label/nixos /mnt
      mkdir -p /mnt/boot
      for _ in {1..3}
      do
        mount /dev/disk/by-label/boot /mnt/boot && break || sleep 1
      done
      swapon "$DISK"2
      nixos-generate-config --root /mnt
      cp ${configuration} /mnt/etc/nixos/configuration.nix
      nixos-install
    '';
}
