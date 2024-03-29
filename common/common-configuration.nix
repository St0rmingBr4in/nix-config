{ system, config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
        consoleMode = "max";
      };
      timeout = 15;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    kernel.sysctl."kernel.sysrq" = 1;
  };

  networking = {
    hostName = lib.mkDefault "nixos-test";
    # nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    networkmanager = {
      enable = false;
      dns = "systemd-resolved";
    };
  };

  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.allowUnfree = true;

  users.users.st0rmingbr4in = {
    description = "Julien DOCHE";
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "mlocate" "networkmanager" "wheel" ];
  };

  environment = {
    variables = {
      EDITOR = "vim";
    };
  };

  programs = {
    adb.enable = true;
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };
    gnupg.agent.enable = true;
    xss-lock.enable = true;
    nm-applet.enable = true;
    zsh.enable = true;
  };

  services = {
    openiscsi = {
      enable = true;
      name = "test";
    };
    autorandr.enable = true;
    chrony.enable = true;
    locate = {
      enable = true;
      locate = pkgs.mlocate;
      interval = "hourly";
      localuser = null;
    };
    openssh.enable = true;

    printing.enable = true;

    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
      extraConfig = ''
        DNSOverTLS=opportunistic
      '';
    };
    xserver = {
      libinput.enable = true;
      autoRepeatDelay = 300;
      autoRepeatInterval = 30;
      layout = "us";
      xkbVariant = "altgr-intl";
      enable = true;
      displayManager = {
        lightdm = {
          enable = true;
          extraConfig = "greeter-hide-users=false";
        };
        defaultSession = "none+i3";
      };
      desktopManager.xterm.enable = false;
      windowManager.i3 = {
        enable = true;
      };
    };
  };

  system.stateVersion = "22.11";
}
