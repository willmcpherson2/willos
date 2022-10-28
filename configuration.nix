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

  services.xserver.desktopManager = {
    gnome.enable = true;
    gdm.enable = true;
  };
  services.gnome.core-utilities.enable = false;

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
      plugins = with pkgs.vimPlugins; [
        fern-vim
      ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    dconf.settings = { };
  };

  system.stateVersion = "22.05";
}
