# vim: set softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent syntax=nix nocompatible :
# Containe
{ config, pkgs, ... }:

{ containers.experiment =
  let hostAddr =  "192.168.200.10";
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
      "/var/run/dbus/system_bus_socket" = {
        hostPath = "/var/run/dbus/system_bus_socket";
	isReadOnly = false;
      };
      "/home/user/.config/pulse" = {
        hostPath = "/home/user/.config/pulse";
	isReadOnly = false;
      };
    };


    privateNetwork = true;
    hostAddress = hostAddr;
    localAddress = "192.168.200.11";
    config =
    { config, pkgs, ... }:
    { boot.tmpOnTmpfs = true;

      environment.systemPackages = with pkgs;
      [
        chromium
	firefox
	emacs
	gnucash
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
	hashedPassword = "$6$MBLQmkIrZvB$2bTHy346qybhFBsefUkcFWUrpjJaggoPaHgLksxY5pkdY0k0/NpzIiJEGhLfrsT0F3351UEl2BjU.rNxPzmEl.";
      };
    };
  };
}