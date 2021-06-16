{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  virtualisation.docker.enable = true;
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    kernel.sysctl."kernel.sysrq" = 1;
  };

  networking = {
    hostName = "nixos-test"; # Define your hostname.
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Paris";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.allowUnfree = true;

  users.users.st0rmingbr4in = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "mlocate" ]; # Enable ‘sudo’ for the user.
  };

  environment = {
    systemPackages = with pkgs; [];
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
    xss-lock.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nm-applet.enable = true;
  };

  services = {
    chrony.enable = true;
    xserver.libinput.enable = true;
    printing.enable = true;
    openssh.enable = true;
    locate = {
      enable = true;
      locate = pkgs.mlocate;
      interval = "hourly";
      localuser = null;
    };
    xserver = {
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

  system.stateVersion = "21.05";
}
