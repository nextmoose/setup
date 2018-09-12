# use chromium --disable-gpu-compositing
let
  foo = "bar";
in
{
  bindMounts = {
#    "/var/run/docker.sock" = {
#      hostPath = "/var/run/docker.sock";
#      isReadOnly = true;
#    };
  };
  config = { config, pkgs, ... }:
  {
    environment.variables.DISPLAY=":0";
    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;
    users.extraUsers.user = {
      name = "user" ;
      group = "users" ;
      extraGroups = [ "wheel" ] ;
      shell = pkgs.bash ;
      createHome = true ;
      home = "/home/user";
      hashedPassword = "$6$MBLQmkIrZvB$2bTHy346qybhFBsefUkcFWUrpjJaggoPaHgLksxY5pkdY0k0/NpzIiJEGhLfrsT0F3351UEl2BjU.rNxPzmEl." ;
      packages = [
	pkgs.docker	
        (import ../custom/shopsafe/default.nix { inherit pkgs; })
      ];
    };
  };
}
