# vim: set softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent syntax=nix nocompatible :
# Containe
{ config, pkgs, ... }:

{ containers.browser =
  let hostAddr =  "192.168.100.10";
  in
  { privateNetwork = true;
    hostAddress = hostAddr;
    localAddress = "192.168.100.11";
    config =
    { config, pkgs, ... }:
    { boot.tmpOnTmpfs = true;

      environment.systemPackages = with pkgs;
      [
        chromium
      ];

      networking.nameservers = [ hostAddr ];

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

      users.mutableUsers = false;

      users.extraUsers.user =
      { name = "user";
        group = "users";
	extraGroups = [ "wheel" ];
        uid = 1000;
        createHome = true;
	home = "/home/user";
        shell = "/run/current-system/sw/bin/bash";
        openssh.authorizedKeys.keyFiles = [ "/etc/nixos/id_rsa.pub" ];
      };
    };
  };
}