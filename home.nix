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
