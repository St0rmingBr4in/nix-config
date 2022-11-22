{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.wget
    pkgs.k9s
    pkgs.kubectl
    pkgs.tree
    pkgs.file
    pkgs.htop
    pkgs.nixfmt
    pkgs.unzip
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    keychain = {
      enable = true;
      keys = [];
    };
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
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
    vim = {
      enable = true;
      settings = {
        mouse = "r";
      };
      plugins = with pkgs.vimPlugins; [ vim-wakatime ale file-line vim-fugitive ];
    };
  };
}
