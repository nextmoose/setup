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
  users.extraUsers.user.extraGroups = [ "wheel" ];
  users.extraUsers.user.packages = [
    (import ./custom/secrets/default.nix { inherit pkgs; })
  ];
  system.stateVersion = "18.03";
}
