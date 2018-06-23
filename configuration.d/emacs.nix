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

let
  myEmacs = pkgs.emacs; 2
  emacsWithPackages = (pkgs.emacsPackagesNgGen myEmacs).emacsWithPackages; 3
in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [ 4
    magit          # ; Integrate git <C-x g>
    zerodark-theme # ; Nicolas' theme
  ]) ++ (with epkgs.melpaPackages; [ 5
    undo-tree      # ; <C-x u> to show the undo tree
    zoom-frm       # ; increase/decrease font size for all buffers %lt;C-x C-+>
  ]) ++ (with epkgs.elpaPackages; [ 6
    auctex         # ; LaTeX mode
    beacon         # ; highlight my cursor when scrolling
    nameless       # ; hide current package name everywhere in elisp code
  ]) ++ [
    pkgs.notmuch   # From main packages set 7
  ])

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