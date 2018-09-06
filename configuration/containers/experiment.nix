{ config, pkgs, ... }:
{
  let
    foo = "bar";
  in
  {
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
	  pkgs.mkpasswd
	];
      };
    };
  };
}
