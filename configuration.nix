{ config, pkgs, ... }:

let
  home-manager = fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-22.11.tar.gz";
  emacs-overlay = fetchTarball
    "https://github.com/nix-community/emacs-overlay/archive/cd444d8f2d284c90a1e898bd102a40176e6dfcfa.tar.gz";
  nix-doom-emacs = fetchTarball
    "https://github.com/nix-community/nix-doom-emacs/archive/85a48dbec84e9c26785b58fecdefa1cfc580aea7.tar.gz";
  doom-emacs = import "${nix-doom-emacs}/modules/home-manager.nix";
in {
  nix = import ./nix.nix;

  system.stateVersion = "22.11";

  imports = [ ./hardware-configuration.nix "${home-manager}/nixos" ];

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

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";
  users.users.will = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    passwordFile = "/etc/passwordFile-will";
  };

  fonts = {
    fonts = with pkgs;
      [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
    fontconfig = {
      defaultFonts = { monospace = [ "JetBrainsMonoNL Nerd Font Mono" ]; };
      localConf = ''
        <selectfont>
          <rejectfont>
            <pattern>
              <patelt name="family">
                <string>TeX Gyre Heros</string>
              </patelt>
            </pattern>
          </rejectfont>
        </selectfont>
      '';
    };
  };

  home-manager.users.will = { pkgs, lib, ... }: {
    home.stateVersion = "22.11";

    nixpkgs.overlays = [ (import emacs-overlay) ];

    imports = [ (doom-emacs { self = nix-doom-emacs; }) ];

    home.packages = with pkgs; [
      # desktop
      gnomeExtensions.night-theme-switcher
      gnomeExtensions.emoji-selector
      gimp
      emacs-all-the-icons-fonts

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
      qmk
      heroku
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
      python310Packages.grip

      (writeShellScriptBin "audio-to-video"
        (builtins.readFile ./bin/audio-to-video.sh))
      (writeShellScriptBin "new-ssh-key"
        (builtins.readFile ./bin/new-ssh-key.sh))
      (writeShellScriptBin "track-willos"
        (builtins.readFile ./bin/track-willos.sh))
      (writeShellScriptBin "ydl" (builtins.readFile ./bin/ydl.sh))
      (writeShellScriptBin "flash-willkbd"
        (builtins.readFile ./bin/flash-willkbd.sh))

      # nix
      rnix-lsp
      nixfmt

      # bash
      nodePackages.bash-language-server

      # c
      gcc
      clang-tools

      # web
      nodejs
      nodePackages.vscode-langservers-extracted
      nodePackages.typescript
      (symlinkJoin {
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
        ncdu = "ncdu --color off";
      };
      bashrcExtra = ''
        export PATH="$HOME/.emacs.d/bin:$PATH"
      '';
      initExtra = ''
        stty -ixon
        set enable-bracketed-paste on
      '';
    };

    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./dot/doom;
      doomPackageDir = pkgs.linkFarm "doom-packages-dir" [
        {
          name = "packages.el";
          path = ./dot/doom/packages.el;
        }
        {
          name = "init.el";
          path = ./dot/doom/init.el;
        }
        {
          name = "config.el";
          path = pkgs.emptyFile;
        }
      ];
      emacsPackage = pkgs.emacsPgtk;
    };

    programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles.will = { extraConfig = builtins.readFile ./dot/user.js; };
    };

    home.file = {
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
        text-scaling-factor = 1.25;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        tap-and-drag = false;
      };
      "org/gnome/desktop/background" = {
        picture-uri =
          "file:///run/current-system/sw/share/backgrounds/gnome/dune-l.svg";
        picture-uri-dark =
          "file:///run/current-system/sw/share/backgrounds/gnome/dune-d.svg";
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
      "org/gtk/settings/file-chooser" = { clock-format = "12h"; };

      "org/gnome/shell/extensions/nightthemeswitcher/gtk-variants" = {
        enabled = true;
      };
      "org/gnome/shell/extensions/nightthemeswitcher/time" = {
        always-enable-ondemand = true;
        nightlight-follow-disable = true;
      };
    };
  };
}
