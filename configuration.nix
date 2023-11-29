{ config, pkgs, ... }:
let
  version = "23.05";
  nixos-hardware = fetchTarball
    "https://github.com/NixOS/nixos-hardware/archive/b006ec52fce23b1d57f6ab4a42d7400732e9a0a2.tar.gz";
  home-manager = fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-${version}.tar.gz";
in
{
  nix = import ./nix.nix;

  system.stateVersion = version;

  imports = [
    ./hardware-configuration.nix
    "${nixos-hardware}/lenovo/thinkpad/l14/amd"
    "${home-manager}/nixos"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "will-lap";
  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";

  services = {
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        defaultSession = "gnome-xorg";
      };
    };
    gnome.core-utilities.enable = false;
    openssh.enable = true;
    ratbagd.enable = true;
    jack = {
      jackd.enable = true;
      alsa.enable = false;
      loopback.enable = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    vmVariant = {
      virtualisation = {
        memorySize = 4096;
        cores = 8;
      };
    };
  };

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "!";
      will = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "jackaudio"
        ];
        hashedPassword = "$y$j9T$NSQIU.lIfojqrEcsuBjFn0$kBar4ZM7y40HXQgwMJnV58a8yW32Znpszu69yW0TH79";
      };
    };
  };

  fonts = {
    fonts = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
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

  home-manager.users.will = (import ./will.nix) version;
}
