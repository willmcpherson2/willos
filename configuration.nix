{ config, pkgs, ... }:

let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz";
  catppuccinAlacritty = fetchTarball "https://github.com/catppuccin/alacritty/archive/main.tar.gz";
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
      gimp

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

      (writeShellScriptBin "audio-to-video" (builtins.readFile ./bin/audio-to-video.sh))
      (writeShellScriptBin "new-ssh-key" (builtins.readFile ./bin/new-ssh-key.sh))
      (writeShellScriptBin "packer-sync" (builtins.readFile ./bin/packer-sync.sh))
      (writeShellScriptBin "track-willos" (builtins.readFile ./bin/track-willos.sh))
      (writeShellScriptBin "ydl" (builtins.readFile ./bin/ydl.sh))

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
      nodePackages.vscode-langservers-extracted
      nodePackages.typescript
      (symlinkJoin
        {
          name = "typescript-language-server";
          paths = [ nodePackages.typescript-language-server ];
          buildInputs = [ makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/typescript-language-server \
              --add-flags --tsserver-path=${nodePackages.typescript}/lib/node_modules/typescript/lib/
          '';
        })

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

      # yaml
      nodePackages.yaml-language-server
    ];

    programs.bash = {
      enable = true;
      historySize = -1;
      historyFileSize = -1;
      historyControl = [ "ignoredups" ];
      shellAliases = {
        diff = "git diff --no-index";
        grep = "grep --color=auto";
        vi = "nvim";
        vim = "nvim";
        ncdu = "ncdu --color off";
      };
      sessionVariables = {
        EDITOR = "nvim";
        PAGER = "page";
        MANPAGER = "page -t man";
        WINIT_UNIX_BACKEND = "x11";
      };
      initExtra = ''
        stty -ixon
        set enable-bracketed-paste on
      '';
    };

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
      alacritty = {
        source = ./dot/alacritty.yml;
        target = ".config/pycritty/saves/alacritty.yml";
      };
      alacrittyLatte = {
        source = "${catppuccinAlacritty}/catppuccin-latte.yml";
        target = ".config/pycritty/themes/latte.yml";
      };
      alacrittyFrappe = {
        source = "${catppuccinAlacritty}/catppuccin-frappe.yml";
        target = ".config/pycritty/themes/frappe.yml";
      };
      neovim = {
        source = ./dot/init.lua;
        target = ".config/nvim/init.lua";
      };
      gitconfig = {
        source = ./dot/gitconfig;
        target = ".config/git/config";
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
        sunrise = "pycritty load alacritty; pycritty -t latte";
        sunset = "pycritty load alacritty; pycritty -t frappe";
      };
    };
  };
}
