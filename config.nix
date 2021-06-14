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
    systemPackages = with pkgs; [
      wget
      slack
      k9s
      kubectl
      ruby
      python3Minimal
      firefox
      google-chrome
      lynx
      tree
      file
      xsel
      htop
      nixfmt
      home-manager
      niv
      thunderbird
      rofi
      autorandr
      arandr
      android-file-transfer

      # linters
      #flawfinder
      cmake-format
      hadolint
      #rpmlint
      vale
      cpplint
    ];
    variables = {
      EDITOR = "vim";
    };
  };

  programs = {
    adb.enable = true;
    xss-lock.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nm-applet.enable = true;
  };

  services = {
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
      displayManager.defaultSession = "none+i3";
      desktopManager.xterm.enable = false;
      windowManager.i3 = {
        enable = true;
      };
    };
  };

  system.stateVersion = "21.05";
}
