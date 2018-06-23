{ config, pkgs, ... }:

{ containers.emacs =

  let hostAddr =  "192.168.101.10";
   in
  { privateNetwork = true;
    hostAddress = hostAddr;
    localAddress = "192.168.101.11";
    config =
    { config, pkgs, ... }:
    { boot.tmpOnTmpfs = true;

      networking.nameservers = [ hostAddr ];

      services.emacs.enable = true;
      services.emacs.package = import /home/cassou/.emacs.d { pkgs = pkgs; };

      services =
      { openssh =
        { enable = true;
          forwardX11 = true;
        };

        emacs.enable = true;

        avahi =
        { enable = true;
          browseDomains = [];
          wideArea = false;
          nssmdns = true;
        };
      };

      programs.ssh.setXAuthLocation = true;

      users.extraUsers.user =
      { name = "user";
        group = "users";
        uid = 1000;
        createHome = true;
        home = "/home/user";
        password = "...."; # TODO: set password
        shell = "/run/current-system/sw/bin/bash";
        openssh.authorizedKeys.keyFiles = [ "/home/user/.ssh/id_rsa.pub" ];
      };
    };
  };
  
  # Caching local DNS resolver, for port 53
  services.unbound = 
    { enable = true;
      extraConfig = "include: /etc/unbound-resolvconf.conf";
      allowedAccess = [ "127.0.0.0/24" "192.168.100.0/24" ];
      interfaces = [ "0.0.0.0" "::0" ];
    };
}