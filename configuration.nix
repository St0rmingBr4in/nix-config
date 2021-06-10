{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz}/nixos")
    ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "nixos-test"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  services.xserver = {
    enable = true;
    displayManager.defaultSession = "none+i3";
    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
        i3blocks
      ];
    };
  };
  
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services.printing.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.xserver.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;

  #users.defaultUserShell = pkgs.zsh;

  users.users.st0rmingbr4in = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "mlocate" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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

  programs.adb.enable = true;
  programs.xss-lock.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.nm-applet.enable = true;
  home-manager.users.st0rmingbr4in = {

    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "alacritty";
        menu = "${pkgs.rofi}/bin/rofi -show run";
      };
    };

    programs = {
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        prezto = {
          enable = true;
          syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "line" "cursor" "root" ];
        };
        oh-my-zsh = {
          enable = true;
          theme = "bureau";
          plugins = [ "sudo" "colored-man-pages" "command-not-found" "extract" "docker" "kubectl"  ];
        };
      };

      git = {
        enable = true;
        userName = "Julien DOCHE";
        userEmail = "julien.doche@gmail.com";
      };
      vim = {
        enable = true;
        settings = {
          mouse = "r";
        };
        plugins = with pkgs.vimPlugins; [ vim-wakatime ale file-line vim-fugitive YouCompleteMe ];
      };
      alacritty = {
        enable = true;
        settings = {
          key_bindings = [
            {
              key = "Return";
              mods = "Control|Shift";
              action = "SpawnNewInstance";
            }
          ];
        };
      };
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.locate = {
    enable = true;
    locate = pkgs.mlocate;
    interval = "hourly";
    localuser = null;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
