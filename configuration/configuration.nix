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
    '';
    loginShellInit = ''
      xhost +local:
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
      (import ./custom/my-browser/default.nix { inherit pkgs; })
      (import ./custom/migration/emacs-development-environment/default.nix { inherit pkgs; })
      (import ./custom/migration/emacs-nixpkgs/default.nix { inherit pkgs; })
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
      pkgs.git
    ];
  };
  system.stateVersion = "18.03";
}
