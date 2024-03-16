{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  system.stateVersion = "23.11";

  imports = [
    ./hardware-configuration.nix
  ];

  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "amdgpu" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  powerManagement.cpuFreqGovernor = "performance";

  networking.hostName = "will-pc";
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
      videoDrivers = [ "amdgpu" ];
    };
    gnome.core-utilities.enable = false;
    openssh.enable = true;
    ratbagd.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
  hardware = {
    pulseaudio.enable = false;
    i2c.enable = true;
  };
  security.rtkit.enable = true;

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

  fonts.packages = [ pkgs.jetbrains-mono ];

  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "!";
      will = {
        isNormalUser = true;
        extraGroups = [ "wheel" "i2c" ];
        hashedPassword = "$y$j9T$NSQIU.lIfojqrEcsuBjFn0$kBar4ZM7y40HXQgwMJnV58a8yW32Znpszu69yW0TH79";
      };
    };
  };

  programs.steam.enable = true;
}
