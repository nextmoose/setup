{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.libinput.enable = true;
  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$MBLQmkIrZvB$2bTHy346qybhFBsefUkcFWUrpjJaggoPaHgLksxY5pkdY0k0/NpzIiJEGhLfrsT0F3351UEl2BjU.rNxPzmEl.";
    packages = [
      pkgs.emacs
    ];
    users.users.root.openssh.authorizedKeys.keys = [
      "ID_RSA.PUB"
    ];
  };
  services = {
    openssh = {
      enable = true;
      forwardX11 = true;
    };
  };
  system.stateVersion = "18.03";
}
