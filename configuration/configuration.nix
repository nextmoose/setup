{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./containers.nix
  ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "duke";
  networking.networkmanager.enable=true;
  networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];
  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "wl01";
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "US/Eastern";
  virtualisation.docker.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.libinput.enable = true;
  security.sudo.wheelNeedsPassword = false;
  programs.bash = {
    shellInit = ''
      date > ~/.date &&
      if [ -f ~/.flag ]
      then
        sudo sh /secrets/wifi.sh &&
        sudo chmod a+rwx /secrets &&
	sudo chmod a+rwx /secrets/. &&
        ${pkgs.gnupg}/bin/gpg --import /secrets/gpg.secret.key &&
	${pkgs.gnupg}/bin/gpg --import-ownertrust /secrets/gpg.owner.trust &&
	${pkgs.gnupg}/bin/gpg2 --import /secrets/gpg2.secret.key &&
	${pkgs.gnupg}/bin/gpg2 --import-ownertrust /secrets/gpg2.owner.trust &&
	${pkgs.pass}/bin/pass init $(${pkgs.gnupg}/bin/gpg --list-keys --with-colon | head --lines 5 | tail --lines 1 | cut --fields 5 --delimiter ":") &&
	${pkgs.pass}/bin/pass git init &&
	${pkgs.pass}/bin/pass git remote add origin https://github.com/nextmoose/secrets.git &&
	${pkgs.pass}/bin/pass git fetch origin master &&
	${pkgs.pass}/bin/pass git checkout origin/master &&
	rm -f ~/.flag
      fi &&
        ${pkgs.xorg.xhost}/bin/xhost +local:
    '';
  };
  users.mutableUsers = false;
  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    hashedPassword = "${PASSWORD_HASH}";
    packages = [
      (import ./custom/secrets/default.nix { inherit pkgs; })
      (import ./custom/migration/example/default.nix { inherit pkgs; })
      (import ./custom/migration/github/default.nix { inherit pkgs; })
      (import ./custom/migration/gpg-key-id/default.nix { inherit pkgs; })
      (import ./custom/migration/init/default.nix { inherit pkgs; })
      (import ./custom/migration/mysecret-editor/default.nix { inherit pkgs; })
      (import ./custom/migration/post-commit/default.nix { inherit pkgs; })
      (import ./custom/migration/pre-push/default.nix { inherit pkgs; })
      (import ./custom/migration/regrind/default.nix { inherit pkgs; })
      (import ./custom/migration/secret-editor/default.nix { inherit pkgs; })
      (import ./custom/my-completions/default.nix { inherit pkgs; })
      pkgs.emacs
      pkgs.mkpasswd
      pkgs.bash-completion
      pkgs.nix-bash-completions
      pkgs.xorg.xhost
      pkgs.browserpass
      pkgs.pass
    ];
  };
  system.stateVersion = "18.03";
}
