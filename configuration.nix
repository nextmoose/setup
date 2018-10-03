{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.isolated.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    libinput.enable = true;
  };
  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  users.extraUsers.user.isNormalUser = true;
  users.extraUsers.user.uid = 1000;
  users.extraUsers.user.extraGroups = [ "wheel" "networkmanager" ];
  users.extraUsers.user.packages = [
    (import ./custom/secrets/default.nix { inherit pkgs; })
    (import ./custom/wifi/default.nix { inherit pkgs; })
    (import ./custom/development-setup/default.nix { inherit pkgs; })
  ];
  programs.bash.shellInit = ''
    wifi
  '';
  system.stateVersion = "18.03";
}
