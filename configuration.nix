{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "duke";
  networking.networkmanager.enable=true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "US/Eastern";

  environment.systemPackages = with pkgs; [
    wget
    vim
    emacs
    chromium
    git
    pass
    gnupg
    gnucash
    deja-dup
    bashmount
    bash-completion
    nix-bash-completions
    lvm2
    paperwork
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.displayManager.auto.enable = true;
  services.xserver.displayManager.user = "user";
  services.xserver.displayManager.default = "i3";

  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  system.stateVersion = "18.03";
}
