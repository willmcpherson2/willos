{ config, pkgs, ... }:

let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz";
in
{
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

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  home-manager.users.will = { pkgs, ... }: {
    home.stateVersion = "22.11";

    home.packages = with pkgs; [
      wofi
      wofi-emoji

      # gnome
      gnome-console
      gnome-connections
      gnome.nautilus
      gnome.totem
      gnome.eog
      gnome.baobab
      gnome.gnome-system-monitor
      gnome.gnome-logs
      gnome.gnome-font-viewer
      gnome.gnome-characters
      gnomeExtensions.night-theme-switcher

      # cli
      git
      file
      tree
      cloc
      ripgrep
      wl-clipboard
      nvimpager
      fd
      htop
      ncdu
      ffmpeg
      youtube-dl

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
      ghci = {
        source = ./dot/ghci;
        target = ".ghci";
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "audio/x-wav" = [ "org.gnome.Totem.desktop" ];
        "audio/mpeg" = [ "org.gnome.Totem.desktop" ];
        "audio/x-vorbis+ogg" = [ "org.gnome.Totem.desktop" ];
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        clock-format = "12h";
        monospace-font-name = "JetBrainsMono Nerd Font Mono 14";
      };
      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = true;
        speed = -0.80;
      };
      "org/gnome/desktop/app-folders" = {
        folder-children = [ ];
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/dune-l.svg";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/dune-d.svg";
      };
      "org/gnome/shell" = {
        enabled-extensions = [ "nightthemeswitcher@romainvigier.fr" ];
        favorite-apps = [ ];
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/Console" = {
        theme = "auto";
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

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "run";
        binding = "<Super>r";
        command = "wofi --show drun";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "emoji";
        binding = "<Super>e";
        command = "wofi-emoji";
      };
    };
  };
}
