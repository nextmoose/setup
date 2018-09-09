# use chromium --disable-gpu-compositing
let
  foo = "bar";
in
{
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
      shell = pkgs.bash ;
      createHome = true ;
      home = "/home/user";
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
