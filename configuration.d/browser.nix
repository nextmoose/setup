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
      [ firefoxWrapper
        chromium
        alsaLib
      ];

      nixpkgs.config =
        let
          plugins = 
          {
            enablePepperPDF = true;
            enableGoogleTalkPlugin = true;
            # jre = true;
          };
        in
        { # firefox = plugins;
          chromium = plugins;
          allowUnfree = true;
        };

      hardware.bumblebee.enable = true;
      environment.variables.PULSE_SERVER = "tcp:" + hostAddr;

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

      users.extraUsers.user =
      { name = "user";
        group = "users";
        uid = 1000;
        createHome = true;
        home = "/tmp";
        password = "...."; # TODO: set password
        shell = "/run/current-system/sw/bin/bash";
        openssh.authorizedKeys.keyFiles = [ "/home/user/.ssh/id_rsa.pub" ];
      };
    };
  };

  # Note, you may need to replace ve-+ with c-+, consult `ip addr` or docs
  networking =
  { nat.enable = true;
    nat.internalInterfaces = ["ve-+"];
    nat.externalInterface = "wlp3s0";
    firewall.extraCommands =
      ''
      ip46tables -A nixos-fw -i ve-+ -p tcp --dport 4713 -j nixos-fw-accept;
      ip46tables -A nixos-fw -i ve-+ -p tcp --dport 631 -j nixos-fw-accept;
      ip46tables -A nixos-fw -i ve-+ -p udp --dport 631 -j nixos-fw-accept;
      ip46tables -A nixos-fw -i ve-+ -p udp --dport 53 -j nixos-fw-accept;
      ip46tables -A nixos-fw -i ve-+ -p tcp --dport 53 -j nixos-fw-accept;
      '';
    useHostResolvConf = false;
  };
  
  # Caching local DNS resolver, for port 53
  services.unbound = 
    { enable = true;
      extraConfig = "include: /etc/unbound-resolvconf.conf";
      allowedAccess = [ "127.0.0.0/24" "192.168.100.0/24" ];
      interfaces = [ "0.0.0.0" "::0" ];
    };
}