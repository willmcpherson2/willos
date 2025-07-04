{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ inputs.rust-overlay.overlays.default ];
  };

  imports = [ inputs.nix-doom-emacs-unstraightened.hmModule ];

  home = {
    stateVersion = "23.11";

    packages = with pkgs; [
      # gnome
      gnome-system-monitor
      nautilus
      baobab
      gnomeExtensions.night-theme-switcher
      gnomeExtensions.emoji-copy
      gnomeExtensions.brightness-control-using-ddcutil

      # media
      ffmpeg
      yt-dlp
      mpv
      screenkey
      gimp
      obs-studio
      guvcview
      gpu-screen-recorder-gtk
      bitwig-studio
      renoise
      blender-hip
      davinci-resolve

      # extra browsers
      chromium
      epiphany

      # voip
      zoom-us
      discord-canary

      # peripherals
      libratbag
      piper
      qmk
      ddcutil

      # gaming
      prismlauncher
      flatpak
      lutris

      # wine
      winetricks
      wineWowPackages.staging
      bottles

      # emacs
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
      pandoc
      python311Packages.grip

      # cli
      wget
      git
      git-lfs
      wl-clipboard
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
      nixd
      nixfmt-rfc-style

      # bash
      nodePackages.bash-language-server

      # c
      (hiPrio gcc)
      clang
      clang-tools
      llvm
      valgrind
      kdePackages.kcachegrind

      # web
      nodejs_24
      nodePackages.vscode-langservers-extracted
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.prettier

      # docker
      nodePackages.dockerfile-language-server-nodejs

      # python
      python3

      # ruby
      ruby
      rubyPackages.solargraph

      # haskell
      haskell.compiler.ghc912
      haskell.packages.ghc912.haskell-language-server
      cabal-install
      haskellPackages.hoogle
      ormolu

      # agda
      agda

      # java
      jdk17

      # scala
      sbt-extras
      metals

      # clojure
      leiningen
      clojure-lsp

      # rust
      (rust-bin.stable."1.88.0".default.override {
        targets = [ "wasm32-unknown-unknown" ];
        extensions = [ "rust-src" "rust-analyzer-preview" ];
      })

      # terraform
      terraform
      terraform-ls

      # godot
      godot_4

      # go
      go
      gopls

      # yaml
      nodePackages.yaml-language-server

      # toml
      taplo

      (writeShellScriptBin "audio-to-video" (builtins.readFile ./bin/audio-to-video.sh))
      (writeShellScriptBin "new-ssh-key" (builtins.readFile ./bin/new-ssh-key.sh))
      (writeShellScriptBin "ydl" (builtins.readFile ./bin/ydl.sh))
      (writeShellScriptBin "drive" (builtins.readFile ./bin/drive.sh))
    ];
    file = {
      gitconfig = {
        source = ./dot/.gitconfig;
        target = ".config/git/config";
      };
      ghci = {
        source = ./dot/.ghci;
        target = ".ghci";
      };
    };
  };

  programs = {
    bash = {
      enable = true;
      historySize = -1;
      historyFileSize = -1;
      historyControl = [ "ignoredups" ];
      initExtra = builtins.readFile ./dot/.bashrc;
    };
    doom-emacs = {
      enable = true;
      doomDir = ./dot/doom;
      emacs = pkgs.emacs-pgtk;
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
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
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "nightthemeswitcher@romainvigier.fr"
        "emoji-copy@felipeftn"
        "display-brightness-ddcutil@themightydeity.github.com"
      ];
    };
    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      manual-schedule = false;
    };
    "org/gnome/shell/extensions/display-brightness-ddcutil" = {
      ddcutil-binary-path = "/etc/profiles/per-user/will/bin/ddcutil";
      show-value-label = true;
    };
    "org/gnome/desktop/datetime" = {
      "automatic-timezone" = true;
    };
    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      clock-show-weekday = true;
      clock-show-seconds = true;
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
        "file:///run/current-system/sw/share/backgrounds/gnome/morphogenesis-l.svg";
      picture-uri-dark =
        "file:///run/current-system/sw/share/backgrounds/gnome/morphogenesis-d.svg";
    };
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
    };
    "org/gtk/settings/file-chooser" = {
      clock-format = "12h";
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
    };
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
    "org/gnome/desktop/a11y" = {
      always-show-universal-access-status = true;
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
    };
  };
}
