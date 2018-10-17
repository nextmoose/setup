{ config, pkgs, ... }:
let secrets = (import ./custom/secrets/default.nix { inherit pkgs; }); 
{
  imports = [
    ./hardware-configuration.nix
    ./password.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.pulseaudio.enable = true;
  programs.bash.shellInit = ''
    if [ ! -f ~/.flag ]
    then
      ${pgks.gnupg}/bin/gpg --import ${secrets}/bin/secrets show gpg.secret.key &&
        ${pkgs.gnupg}/bin/gpg --import-ownertrust ${secrets}/bin/secrets show gpg.owner.trust &&
        ${pgks.gnupg}/bin/gpg2 --import ${secrets}/bin/secrets show gpg2.secret.key &&
        ${pkgs.gnupg}/bin/gpg2 --import-ownertrust ${secrets}/bin/secrets show gpg2.owner.trust &&
	touch ~/.flag &&
        true
    fi &&
    true
  '';
  security.sudo.wheelNeedsPassword = false;
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    libinput.enable = true;
  };
  sound.enable = true;
  users = {
    mutableUsers = false;
    extraUsers.user = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      packages = [
        (import ./custom/secrets/default.nix { inherit pkgs; })
      ];
    };
  };
  virtualisation.docker.enable = true;
  system.stateVersion = "18.03";
}
