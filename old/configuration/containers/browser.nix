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

      environment.variables = {
        DISPLAY=":0";
	GPG_SECRET_KEY_FILE="/secrets/gpg.secret.key";
	GPG_OWNER_TRUST_FILE="/secrets/gpg.owner.trust";
	GPG2_SECRET_KEY_FILE="/secrets/gpg2.secret.key";
	GPG2_OWNER_TRUST_FILE="/secrets/gpg2.owner.trust";
	ORIGIN_HOST="github.com";
	ORIGIN_PORT="22";
	ORIGIN_USER="git";
	ORIGIN_ORGANIZATION="nextmoose";
	ORIGIN_REPOSITORY="credentials";
	ORIGIN_ID_RSA_FILE="/secrets/origin.id_rsa";
	ORIGIN_KNOWN_HOSTS_FILE="/secrets/origin.known_hosts";
	COMMITTER_NAME="Emory Merryman";
	COMMITTER_EMAIL="emory.merryman@gmail.com";
      };


    security.sudo.wheelNeedsPassword = false;
    users.mutableUsers = false;
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
        (import ../custom/browser/default.nix { inherit pkgs; })
      ];
    };
  };
}
