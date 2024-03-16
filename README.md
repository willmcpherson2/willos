# Will's OS

This is my personal Nix config. You are encouraged to copy from it, but it's not intended for wholesale use (unless you also want to be `will@will-pc`)

Rebuild:

```sh
sudo nixos-rebuild switch
```

Build VM:

```sh
nixos-rebuild build-vm
./result/bin/run-will-pc-vm
```

## Emacs

I [install](https://github.com/doomemacs/doomemacs#install) Doom Emacs imperatively. All configuration files and system dependencies are installed declaratively.
