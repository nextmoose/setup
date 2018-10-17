{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./password.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  users.extraUsers.user.isNormalUser = true;
  users.extraUsers.user.extraGroups = [ "wheel" "docker" ];
  users.extraUsers.user.packages = [
    (import ./custom/secrets/default.nix { inherit pkgs; })
  ];
  virtualisation.docker.enable = true;
  system.stateVersion = "18.03";
}
