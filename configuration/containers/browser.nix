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
    "/secrets" = {
      hostPath = "/secrets";
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
        { firefox = plugins;
          chromium = plugins;
          allowUnfree = true;
        };
      hardware.pulseaudio.enable = true;
      hardware.bumblebee.enable = true;

      environment.variables.DISPLAY=":0";


    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;
    programs.bash = {
      shellInit = ''
        my-browser &&
        chromium --disable-gpu
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
        (import ../custom/my-browser/default.nix { inherit pkgs; })
        (import ../custom/migration/gpg-key-id/default.nix { inherit pkgs; })
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
