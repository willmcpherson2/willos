# Will's OS

This is my personal Nix config. You are encouraged to copy from it, but it's not intended for wholesale use (unless you also want to be `will@will-lap`)

From the NixOS live CD:

```sh
sudo nix-shell https://github.com/willmcpherson2/willos/archive/main.tar.gz
```

Rebuild:

```sh
sudo nixos-rebuild switch
```

Build VM:

```sh
nixos-rebuild build-vm
./result/bin/run-will-lap-vm
```

## Emacs

[init.el](will/dot/init.el) and [early-init.el](will/dot/early-init.el) bootstrap [straight.el](https://github.com/radian-software/straight.el), so they can be used outside of Nix.
