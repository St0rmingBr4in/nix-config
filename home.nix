{ config, pkgs, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "${pkgs.rofi}/bin/rofi -show run";
      # switch between workspaces
    };
  };

  services = {
    cbatticon = {
      enable = true;
      commandCriticalLevel = "notify-send \"battery critical!\"";
    };
  };

  home.packages = [
    pkgs.xfce.xfce4-screenshooter
    pkgs.black
  ];

  programs = {
    bat.enable = true;
    keychain.enable = true;
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
    ssh = {
      enable = true;
      compression = true;
      matchBlocks."*".user = "j.doche";
    };
    vim = {
      enable = true;
      settings = {
        mouse = "r";
      };
      plugins = with pkgs.vimPlugins; [ vim-wakatime ale file-line vim-fugitive ];
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
}
