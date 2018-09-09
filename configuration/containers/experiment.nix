let
  foo = "bar";
  hostAddr =  "192.168.100.10";
in
{
    privateNetwork = true;
    hostAddress = hostAddr;
    localAddress = "192.168.100.11";


  bindMounts = {
    "/tmp/.X11-unix" = {
      hostPath = "/tmp/.X11-unix";
      isReadOnly = true;
    };
    "/run/user/1000/pulse" = {
      hostPath = "/run/user/1000/pulse";
      isReadOnly = false;
    };
    "/etc/machine-id" = {
      hostPath = "/etc/machine-id";
      isReadOnly = false;
    };
#    "/var/run/dbus/system_bus_socket" = {
#      hostPath = "/var/run/bus/system_bus_socket";
#      isReadOnly = false;    				     
#    };
#    "/var/lib/dbus" = {
#      hostPath = "/var/lib/dbus";
#      isReadOnly = false;
#    };
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
        { firefox = plugins;
          chromium = plugins;
          allowUnfree = true;
        };
      hardware.pulseaudio.enable = true;
      hardware.bumblebee.enable = true;
      environment.variables.PULSE_SERVER = "tcp:" + hostAddr;

      services =
      { openssh =
        { enable = true;
          forwardX11 = true;
        };

        avahi =
        { enable = true;
          browseDomains = [];
          wideArea = false;
          nssmdns = true;
        };
      };

      programs.ssh.setXAuthLocation = true;


    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;
    programs.bash = {
      shellInit = ''
        export DISPLAY=:0
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
    users.extraUsers.user = {
      name = "user" ;
      group = "users" ;
      extraGroups = [ "wheel" ] ;
      home = "/home/user" ;
      shell = pkgs.bash ;
      openssh.authorizedKeys.keyFiles = [ "/home/user/.ssh/id_rsa.pub" ];
      hashedPassword = "$6$MBLQmkIrZvB$2bTHy346qybhFBsefUkcFWUrpjJaggoPaHgLksxY5pkdY0k0/NpzIiJEGhLfrsT0F3351UEl2BjU.rNxPzmEl." ;
      packages = [
	pkgs.firefoxWrapper
	pkgs.emacs
	pkgs.mkpasswd
	pkgs.chromium
	pkgs.browserpass
	pkgs.pass
	pkgs.git
	pkgs.gnupg
      ];
    };
  };
}
