version: { pkgs, lib, ... }:
let
  rust-overlay = import
    (fetchTarball
      "https://github.com/oxalica/rust-overlay/archive/9dd940c967502f844eacea52a61e9596268d4f70.tar.gz");
in
{
  nixpkgs = {
    config = { allowUnfree = true; };
    overlays = [
      rust-overlay
    ];
  };

  home = {
    stateVersion = version;

    packages = with pkgs; [
      # gnome
      gnome.gnome-system-monitor
      gnome.nautilus
      gnomeExtensions.night-theme-switcher
      gnomeExtensions.emoji-selector

      # media
      ffmpeg
      youtube-dl
      mpv
      screenkey
      gimp
      obs-studio
      bitwig-studio
      blender
      kdenlive

      # extra browsers
      chromium
      epiphany

      # voip
      zoom-us
      discord

      # peripherals
      libratbag
      piper
      qmk

      # gaming
      steam
      prismlauncher
      flatpak
      lutris
      winetricks
      (wineWowPackages.full.override {
        wineRelease = "staging";
        mingwSupport = true;
      })

      # emacs
      emacs29
      emacs-all-the-icons-fonts
      (aspellWithDicts (dicts: with dicts; [
        en
        en-computers
        en-science
      ]))
      (texlive.combine {
        inherit (texlive)
          scheme-full
          wrapfig
          amsmath
          ulem
          hyperref
          capt-of;
      })

      # cli
      git
      gh
      xclip
      file
      tree
      cloc
      ripgrep
      fd
      ncdu
      unzip
      google-cloud-sdk
      rclone

      # nix
      nil

      # bash
      nodePackages.bash-language-server

      # c
      gcc
      clang-tools

      # web
      nodejs
      nodePackages.vscode-langservers-extracted
      nodePackages.typescript
      nodePackages.typescript-language-server

      # python
      python310
      python310Packages.python-lsp-server

      # ruby
      ruby
      rubyPackages.solargraph

      # haskell
      ghc
      cabal-install
      haskell-language-server
      haskellPackages.hoogle
      ormolu

      # coq
      coq

      # java
      jdk17

      # clojure
      leiningen
      clojure-lsp

      # scala
      sbt
      metals

      # rust
      (rust-bin.stable."1.67.1".default.override {
        targets = [ "wasm32-unknown-unknown" ];
        extensions = [ "rust-src" "rust-analyzer-preview" ];
      })
      wasm-bindgen-cli

      # yaml
      nodePackages.yaml-language-server

      # toml
      taplo

      (writeShellScriptBin "audio-to-video" (builtins.readFile ./bin/audio-to-video.sh))
      (writeShellScriptBin "new-ssh-key" (builtins.readFile ./bin/new-ssh-key.sh))
      (writeShellScriptBin "track-willos" (builtins.readFile ./bin/track-willos.sh))
      (writeShellScriptBin "ydl" (builtins.readFile ./bin/ydl.sh))
      (writeShellScriptBin "drive" (builtins.readFile ./bin/drive.sh))
    ];
    file = {
      gitconfig = {
        source = ./dot/gitconfig;
        target = ".config/git/config";
      };
      init-el = {
        source = ./dot/init.el;
        target = ".emacs.d/init.el";
      };
      early-init-el = {
        source = ./dot/early-init.el;
        target = ".emacs.d/early-init.el";
      };
      ghci = {
        source = ./dot/ghci;
        target = ".ghci";
      };
      discord = {
        source = ./dot/discord.json;
        target = ".config/discord/settings.json";
      };
    };
  };

  programs = {
    bash = {
      enable = true;
      historySize = -1;
      historyFileSize = -1;
      historyControl = [ "ignoredups" ];
      initExtra = ''
        stty -ixon
        set enable-bracketed-paste on
        [ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/bash"
      '';
    };
    firefox = {
      enable = true;
      profiles.will = { extraConfig = builtins.readFile ./dot/user.js; };
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "image/jpeg" = "firefox.desktop";
        "image/png" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "text/uri-list" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };
    configFile."mimeapps.list".force = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = true;
      enable-animations = false;
      text-scaling-factor = 1.25;
      enable-hot-corners = false;
    };
    "org/gnome/gnome-system-monitor" = {
      show-dependencies = true;
    };
    "org/gnome/system/location" = {
      enabled = true;
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "compose:rctrl" "lv3:ralt_switch" ];
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      tap-and-drag = false;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
      accel-profile = "flat";
      speed = 0.5;
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
    "org/gtk/settings/file-chooser" = {
      clock-format = "12h";
    };
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
    "org/gnome/shell/extensions/nightthemeswitcher/gtk-variants" = {
      enabled = true;
    };
    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      always-enable-ondemand = true;
      nightlight-follow-disable = true;
      manual-schedule = false;
    };
  };
}
