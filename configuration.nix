{ config, pkgs, ... }:

let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz";
in
{
  nix = import ./nix.nix;

  system.stateVersion = "22.11";

  imports = [
    ./hardware-configuration.nix
    "${home-manager}/nixos"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "will-lap";

  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
  services.gnome.core-utilities.enable = false;

  services.openssh.enable = true;

  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";
  users.users.will = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    passwordFile = "/etc/passwordFile-will";
  };

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMonoNL Nerd Font Mono" ];
      };
    };
  };

  home-manager.users.will = { pkgs, lib, ... }: {
    home.stateVersion = "22.11";

    home.packages = with pkgs; [
      # desktop
      gnomeExtensions.night-theme-switcher
      gnomeExtensions.emoji-selector
      catppuccin-gtk
      alacritty

      # cli
      git
      file
      tree
      cloc
      ripgrep
      wl-clipboard
      page
      fd
      htop
      ncdu
      ffmpeg
      youtube-dl
      unzip
      appimage-run
      pycritty

      # nix
      rnix-lsp

      # bash
      nodePackages.bash-language-server

      # lua
      sumneko-lua-language-server

      # c
      gcc
      clang-tools

      # web
      nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted

      # python
      python310
      python310Packages.python-lsp-server

      # haskell
      ghc
      cabal-install
      haskell-language-server
      haskellPackages.hoogle

      # rust
      rustc
      cargo
      rustfmt
      rust-analyzer
    ];

    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ packer-nvim ];
    };

    programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles.will = {
        extraConfig = builtins.readFile ./dot/user.js;
      };
    };

    home.file = {
      alacritty-latte = {
        source = ./dot/latte.yml;
        target = ".config/pycritty/saves/latte.yml";
      };
      alacritty-frappe = {
        source = ./dot/frappe.yml;
        target = ".config/pycritty/saves/frappe.yml";
      };
      neovim = {
        source = ./dot/init.lua;
        target = ".config/nvim/init.lua";
      };
      gitconfig = {
        source = ./dot/gitconfig;
        target = ".gitconfig";
      };
      bashrc = {
        source = ./dot/bashrc;
        target = ".bashrc";
      };
      profile = {
        source = ./dot/profile;
        target = ".profile";
      };
      ghci = {
        source = ./dot/ghci;
        target = ".ghci";
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        clock-format = "12h";
        enable-animations = false;
      };
      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = true;
        speed = -0.80;
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/dune-l.svg";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/dune-d.svg";
      };
      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 0;
      };
      "org/gnome/shell" = {
        enabled-extensions = [
          "nightthemeswitcher@romainvigier.fr"
          "emoji-selector@maestroschan.fr"
        ];
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
      "org/gtk/settings/file-chooser" = {
        clock-format = "12h";
      };

      "org/gnome/shell/extensions/nightthemeswitcher/gtk-variants" = {
        enabled = true;
      };
      "org/gnome/shell/extensions/nightthemeswitcher/time" = {
        always-enable-ondemand = true;
        nightlight-follow-disable = true;
      };
      "org/gnome/shell/extensions/nightthemeswitcher/commands" = {
        enabled = true;
        sunrise = "pycritty load latte";
        sunset = "pycritty load frappe";
      };
    };
  };
}
