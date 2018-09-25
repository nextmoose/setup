let
  foo = "bar";
in
{
  bindMounts = {
    "/tmp/.X11-unix" = {
      hostPath = "/tmp/.X11-unix";
      isReadOnly = true;
    };
    "/secrets" = {
      hostPath = "/secrets";
      isReadOnly = true;
    };
  };
  config = { config, pkgs, ... }:
  {
      environment.variables = {
        DISPLAY=":0";
      };

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
        pkgs.gnucash
      ];
    };
  };
}
