{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  containers = {
    experiment = {
      bindMounts = {
        "/home/user/host" = {
	  hostPath = "/";
	  isReadOnly = true;
	};
	"/tmp/.X11-unix" = {
	  hostPath = "/tmp/.X11-unix";
	  isReadOnly = true;
	};
      };
      config = { config, pkgs, ... }:
      {
        security.sudo.wheelNeedsPassword = false;
	users.mutableUsers = false;
	programs.bash = {
	  shellInit = ''
	    export DISPLAY=:0
	  '';
	  loginShellInit = ''
	  '';
	};
	users.extraUsers.user = {
	  name = "user" ;
	  group = "user" ;
	  extraGroups = [ "wheel" ] ;
	  home = "/home/user" ;
	  shell = pkgs.bash ;
	  hashedPassword = "$6$MBLQmkIrZvB$2bTHy346qybhFBsefUkcFWUrpjJaggoPaHgLksxY5pkdY0k0/NpzIiJEGhLfrsT0F3351UEl2BjU.rNxPzmEl." ;
	  packages = [
	    pkgs.firefox
	    pkgs.emacs
	  ]
	};
      };
    };
  };

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

  users.mutableUsers = false;
  
  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "${PASSWORD_HASH}";
    packages = [
      (import ./custom/emacs.nix { inherit pkgs; })
      (import ./custom/init/default.nix { inherit pkgs; })
    ];
  };
  
  system.stateVersion = "18.03";
}
