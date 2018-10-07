{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./configuration.isolated.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking = {
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "wl01";
    };
  };
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "US/Eastern";
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    libinput.enable = true;
  };
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  security.sudo.wheelNeedsPassword = false;
  programs.bash.shellInit = ''
    wifi
  '';
  users.mutableUsers = false;
  users.extraUsers.user.isNormalUser = true;
  users.extraUsers.user.extraGroups = [ "wheel" "networkmanager" "vboxusers" "docker" ];
  users.extraUsers.user.packages = [
    pkgs.chromium
    pkgs.emacs
    pkgs.gnupg
    pkgs.pass
    pkgs.git
    (import ./custom/secrets/default.nix { inherit pkgs; })
    (import ./custom/wifi/default.nix { inherit pkgs; })
    (import ./custom/development-setup/default.nix { inherit pkgs; })
    (import ./custom/old-pass/default.nix { inherit pkgs; })
  ];
  system.stateVersion = "18.03";
}
