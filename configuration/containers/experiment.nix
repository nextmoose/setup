# vim: set softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent syntax=nix nocompatible :
# Containe
{ config, pkgs, ... }:

{ containers.experiment =
  let hostAddr =  "192.168.200.10";
  in
  {
    bindMounts = {
      "/verification" = {
        hostPath = "/";
	isReadOnly = true;
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
        pkgs.chromium
      ];

      networking.nameservers = [ hostAddr ];

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