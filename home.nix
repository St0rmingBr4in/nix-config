{ config, pkgs, ... }:

{
  xsession = {
    enable = true;
    initExtra = "autorandr -c default";
    windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "alacritty";
        menu = "${pkgs.rofi}/bin/rofi -show run";
        defaultWorkspace = "workspace number 1";
        focus.followMouse = false;
        workspaceAutoBackAndForth = true;
        workspaceLayout = "stacking";
        # keybindings = { "Mod1+Tab" = "workspace back_and_forth"; };
      };
    };
  };

  services = {
    polybar = {
      enable = true;
      script = "polybar bar &";
    };
    cbatticon = {
      enable = true;
      commandCriticalLevel = ''notify-send "battery critical!"'';
    };
    gpg-agent = {
      enable = true;
      enableSshSupport = true

      ;
    };
  };

  home = {
    shellAliases = {
      "cat" = "bat";
    };
    sessionVariables = { EDITOR = "vim"; };
    packages = [
      pkgs.xfce.xfce4-screenshooter
      pkgs.xfce.xfce4-notifyd
      pkgs.black
      pkgs.git-review
      pkgs.wget
      pkgs.slack
      pkgs.k9s
      pkgs.kubectl
      pkgs.ruby
      pkgs.google-chrome
      pkgs.lynx
      pkgs.tree
      pkgs.nixfmt
      pkgs.gnumake
      pkgs.file
      pkgs.xsel
      pkgs.htop
      pkgs.nixfmt
      pkgs.thunderbird
      pkgs.rofi
      pkgs.arandr
      pkgs.android-file-transfer
      pkgs.unzip
      pkgs.xfce.xfce4-notifyd

      # Linters
      pkgs.flawfinder
      pkgs.cmake-format
      pkgs.hadolint
      pkgs.vale
      pkgs.cpplint
      pkgs.statix

      pkgs.deluge
      pkgs.libnotify
      pkgs.bind
      pkgs.cryptsetup
      pkgs.fluxcd
      pkgs.glances
      pkgs.sops
      pkgs.iperf

      pkgs.discord
      pkgs.spotify
      pkgs.pavucontrol
      pkgs.nfs-utils
      pkgs.parted
      pkgs.python3Minimal
      pkgs.efibootmgr

      pkgs.gimp
      pkgs.crane
      pkgs.kubernetes-helm
      pkgs.prismlauncher
      pkgs.smartmontools
      pkgs.nodePackages.cdk8s-cli
      pkgs.nodePackages.npm
      pkgs.pipenv
      pkgs.nodejs
      pkgs.kustomize
      pkgs.openssl
    ];
    stateVersion = "22.11";
  };

  programs = {
    autorandr.enable = true;
    bat.enable = true;
    feh.enable = true;
    fzf.enable = true;
    jq.enable = true;
    keychain = {
      enable = true;
      keys = [ ];
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      #prezto = {
      #  enable = true;
      #  syntaxHighlighting.highlighters =
      #    [ "main" "brackets" "pattern" "line" "cursor" "root" ];
      #};
      oh-my-zsh = {
        enable = true;
        theme = "sorin";
        plugins = [
          "sudo"
          "colored-man-pages"
          "command-not-found"
          "extract"
          "docker"
          "kubectl"
        ];
      };
    };
    git = {
      enable = true;
      userName = "Julien DOCHE";
      userEmail = "julien.doche@gmail.com";
      aliases = {
        lg = "log --oneline --graph";
        sttaus = "!git status";
      };
    };
    ssh = {
      enable = true;
      compression = true;
      matchBlocks."*" = {
        user = "root";
        extraOptions = { AddKeysToAgent = "yes"; };
      };
    };
    vim = {
      enable = true;
      settings = { mouse = "r"; };
      plugins = with pkgs.vimPlugins; [
        vim-wakatime
        ale
        file-line
        vim-fugitive
      ];
    };
    neovim = {
      enable = true;
      vimAlias = true;
      extraConfig = ''
        set mouse=r
        function! s:DiffWithSaved()
          let filetype=&ft
          diffthis
          vnew | r # | normal! 1Gdd
          diffthis
          exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
        endfunction
        com! DiffSaved call s:DiffWithSaved()
      '';
      plugins = with pkgs.vimPlugins; [
        file-line
        vim-fugitive
        yankring
        vim-nix
        {
          plugin = ale;
          config = ''
            let g:ale_fixers = {}
            let g:ale_fixers.python = ['black']
            let g:ale_fixers.nix = ['nixfmt']
          '';
        }
      ];
    };

    alacritty = {
      enable = true;
      settings = {
        scrolling.history = 100000;
        key_bindings = [{
          key = "Return";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }];
      };
    };
  };
}
