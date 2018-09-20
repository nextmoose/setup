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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN4cXRk9jhThC31B88mR4DnZDu3IR4qFcM92LZbacNwZsgIkFMFbzh/afsw+XOo6BARUKENrTW+0ekUNJAaYYZ5bBxMFtuSGeaOrHDQZrmWgKevZzG9G3DwDY/7sTZuqVVCP8f7q5yT/WIafgf9mn2NDcq4zuo2oIYnXnDF6dCu5IVQ11054RNceqe4HSaB4Rg41C+5HCj6sKAIZGycNHVCZN52tlTVPNUHw/K9fj0yqNakYFgDHauvugq810Tyal+MLDIQ+PGOvh014rTvceehqX+KV2sL5IDQmx3C4G+tB62onyPW6q6ltfcXAx3W9ZBeuUuPghKegTXh1t9ZiGV "
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
