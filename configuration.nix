{ config, pkgs, ... }:

let
  willos = /home/will/willos;
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

  users.users.will = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager.users.will = { pkgs, ... }: {
    home.packages = with pkgs; [
      tree
    ];

    programs.git = {
      enable = true;
      userName = "William McPherson";
      userEmail = "willmcpherson2@gmail.com";
    };

    programs.neovim = {
      enable = true;
      extraConfig = "luafile ${willos}/init.lua";
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter
        fern-vim
        vim-fugitive
        vim-sleuth
        vim-commentary
      ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    programs.gnome-terminal = {
      enable = true;
      profile.will = {
        default = true;
        visibleName = "will";
        audibleBell = false;
        scrollOnOutput = true;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        clock-format = "12h";
      };
      "org/gtk/settings/file-chooser" = {
        clock-format = "12h";
      };
      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = true;
        speed = -0.67;
      };
      "org/gnome/desktop/session" = {
        idle-delay = "uint32 0";
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/terminal/legacy/profiles:/:will" = {
        default-size-columns = 150;
        default-size-rows = 50;
      };
    };
  };

  system.stateVersion = "22.05";
}
