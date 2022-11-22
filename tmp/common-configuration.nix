{ config, pkgs, lib, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
    kernel.sysctl."kernel.sysrq" = 1;
  };

  networking = {
    hostName = lib.mkDefault "nixos-test";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Paris";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

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

  services = {
    chrony.enable = true;
    openssh.enable = true;
  };

  system.stateVersion = "22.05";
}
