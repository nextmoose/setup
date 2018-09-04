{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./containers/browser.nix
  ];

  containers = {
    experiment = (import ./custom/experiment.nix);
  };

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
    chromium
    git
    pass
    gnupg
    bash-completion
    nix-bash-completions
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.libinput.enable = true;
  
  security.sudo.wheelNeedsPassword = false;
  
  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    packages = [
      (import ./custom/emacs.nix { inherit pkgs; })
      (import ./custom/init/default.nix { inherit pkgs; })
    ];
  };
  
  system.stateVersion = "18.03";
}
