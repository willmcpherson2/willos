{
  inputs,
  pkgs,
  ...
}: {
  system.stateVersion = "23.11";

  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];


  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  boot = {
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
      displayManager.gdm.enable = true;
    };
    displayManager.defaultSession = "gnome";
    gnome.core-utilities.enable = false;
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
    amdgpu.opencl.enable = true;
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
