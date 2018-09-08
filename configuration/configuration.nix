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

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "US/Eastern";

  environment.systemPackages = with pkgs; [
    chromium
    firefox
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

  programs.bash = {
    shellInit = ''
      my-completions &&
      date >> /tmp/shellInit.log.txt
    '';
    loginShellInit = ''
      date >> /tmp/loginShellInit.log.txt &&
      xhost +local:
    '';
  };
  

  programs.chromium = {
    enable = true;
    extensions = [
      "naepdomgkenhinolocfifgehidddafch"
    ];
  };
  programs.browserpass = {
    enable = true;
  };

  users.mutableUsers = false;
  
  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "${PASSWORD_HASH}";
    packages = [
      (import ./custom/init/default.nix { inherit pkgs; })
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
];
  };
  
  system.stateVersion = "18.03";
}
