{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "duke";
  networking.networkmanager.enable=true;

  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "wlp3s0";
  networking.firewall.extraCommands =
    ''
      ip46tables -A nixos-fw -i ve-+ -p tcp --dport 4713 -j nixos-fw-accept;
      ip46tables -A nixos-fw -i ve-+ -p tcp --dport 631 -j nixos-fw-accept;
      ip46tables -A nixos-fw -i ve-+ -p udp --dport 631 -j nixos-fw-accept;
      ip46tables -A nixos-fw -i ve-+ -p udp --dport 53 -j nixos-fw-accept;
      ip46tables -A nixos-fw -i ve-+ -p tcp --dport 53 -j nixos-fw-accept;
    '';
  networking.useHostResolvConf = false;

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
    bashmount
    bash-completion
    nix-bash-completions
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.libinput.enable = true;

  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  system.stateVersion = "18.03";

  programs.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enable = true;

}
