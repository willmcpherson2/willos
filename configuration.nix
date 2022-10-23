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

  users.users.will = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager.users.will = { pkgs, ... }: {
    home.packages = with pkgs; [
      tree
    ];

    programs.bash.enable = true;

    xsession.enable = true;
    xsession.windowManager.xmonad.enable = true;

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
  };

  system.stateVersion = "22.05";
}
