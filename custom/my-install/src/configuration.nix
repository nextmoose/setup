{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services = {
    openssh = {
      enable = true;
      forwardX11 = true;
    };
    xserver = {
      enable = true;
      windowManager.i3.enable = true;
      libinput.enable = true;
    };
  };
  security.sudo.wheelNeedsPassword = false;
  programs.secrets.message="goodbye";
  users.mutableUsers = false;
  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    hashedPassword = "HASHED_PASSWORD";
    packages = [
      (import ./custom/secrets/default.nix { inherit pkgs; })
    ];
    openssh.authorizedKeys.keys = [
      "AUTHORIZED_KEY_PUBLIC"
    ];
  };
  system.stateVersion = "18.03";
}
