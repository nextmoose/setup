let
  foo = "bar";
  hostAddr =  "192.168.200.10";
in
{

privateNetwork = true;
    hostAddress = hostAddr;
    localAddress = "192.168.200.11";

  bindMounts = {
    "/tmp/.X11-unix" = {
      hostPath = "/tmp/.X11-unix";
      isReadOnly = true;
    };
  };
  config = { config, pkgs, ... }:
  {

      nixpkgs.config =
        let
          plugins = 
          {
	    enableGoogleTalkPlugin = true;
            # jre = true;
          };
        in
        { # firefox = plugins;
          chromium = plugins;
          allowUnfree = true;
        };
      hardware.pulseaudio.enable = true;
      hardware.bumblebee.enable = true;
      environment.variables.PULSE_SERVER = "tcp:"+hostAddr;


      networking.nameservers = [ hostAddr ];

    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;
    programs.bash = {
      shellInit = ''
        export DISPLAY=:0
      '';
    };
    users.extraUsers.user = {
      name = "user" ;
      group = "users" ;
      extraGroups = [ "wheel" ] ;
      home = "/home/user" ;
      shell = pkgs.bash ;
      hashedPassword = "$6$MBLQmkIrZvB$2bTHy346qybhFBsefUkcFWUrpjJaggoPaHgLksxY5pkdY0k0/NpzIiJEGhLfrsT0F3351UEl2BjU.rNxPzmEl." ;
      packages = [
	pkgs.firefox
	pkgs.emacs
	pkgs.mkpasswd
	pkgs.chromium
      ];
    };
  };
}
