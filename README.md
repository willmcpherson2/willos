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

## Emacs

I'm using Emacs 30.0.50 with pgtk (for Wayland), via [emacs-overlay](https://github.com/nix-community/emacs-overlay).

The overlay provides `emacsWithPackagesFromUsePackage`, which reads my [emacs.el](dot/emacs.el). Because I've enabled `alwaysEnsure` in Nix and `use-package-always-ensure` in Emacs, my config is declarative but will auto-install on other systems![1] If you add packages you must `nixos-rebuild`, but otherwise, you can just `M-x eval-buffer`.

Read more about it [here](https://github.com/nix-community/emacs-overlay#extra-library-functionality)

[1] I haven't tested this yet...
