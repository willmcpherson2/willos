{ config, pkgs, ... }:

let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports = [
    ./hardware-configuration.nix
    "${home-manager}/nixos"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "will-vm";

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
    home.packages = with pkgs; [
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
      file
      tree
      cloc
      ripgrep
      wl-clipboard

      # apps
      firefox

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

    programs.bash = {
      enable = true;
      bashrcExtra = builtins.readFile ./bashrc;
    };

    programs.git = {
      enable = true;
      userName = "William McPherson";
      userEmail = "willmcpherson2@gmail.com";
      extraConfig = {
        core.editor = "nvim";
        init.defaultBranch = "main";
        commit.verbose = true;
      };
    };

    programs.neovim = {
      enable = true;
      extraConfig = "luafile ${./init.lua}";
      plugins = with pkgs.vimPlugins; [ packer-nvim ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    home.file.ghci = {
      source = ./ghci;
      target = ".ghci";
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
        speed = -0.67;
      };
      "org/gnome/desktop/app-folders" = {
        folder-children = [ ];
      };
      "org/gnome/shell" = {
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
    };
  };

  system.stateVersion = "22.05";
}
