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

  services.openssh.enable = true;

  users.mutableUsers = false;
  users.users.root.hashedPassword = "!";
  users.users.will = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    passwordFile = "/etc/passwordFile-will";
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
      extraConfig = "luafile ${./init.lua}";
      plugins = with pkgs.vimPlugins; [ packer-nvim ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };

  system.stateVersion = "22.05";
}
