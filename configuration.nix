# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.extraHosts =
  ''
    127.0.0.2 gitlab
  '';
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable=true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "US/Eastern";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim
    emacs
    chromium
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.windowManager.i3.enable = true;

  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.docker = {};
  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."gitlab" = {
      enableACME = false;
      forceSSL = false;
      locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
    };
  };

  virtualization.docker.enable = true;

  virtualization.virtualbox.host.enable = true;

  services.gitlab = {
    enable = true;
    databasePassword = "eXaMpl3";
    initialRootPassword = "UseNixOS!";
    https = true;
    host = "gitlab";
    port = 443;
    user = "git";
    group = "git";
  secrets = {
    db = "uPgq1gtwwHiatiuE0YHqbGa5lEIXH7fMsvuTNgdzJi8P0Dg12gibTzBQbq5LT7PNzcc3BP9P1snHVnduqtGF43PgrQtU7XL93ts6gqe9CBNhjtaqUwutQUDkygP5NrV6";
    secret = "devzJ0Tz0POiDBlrpWmcsjjrLaltyiAdS8TtgT9YNBOoUcDsfppiY3IXZjMVtKgXrFImIennFGOpPN8IkP8ATXpRgDD5rxVnKuTTwYQaci2NtaV1XxOQGjdIE50VGsR3";
    otp = "e1GATJVuS2sUh7jxiPzZPre4qtzGGaS22FR50Xs1TerRVdgI3CBVUi5XYtQ38W4xFeS4mDqi5cQjExE838iViSzCdcG19XSL6qNsfokQP9JugwiftmhmCadtsnHErBMI";
    jws = ''
      -----BEGIN RSA PRIVATE KEY-----
      MIIEpAIBAAKCAQEArrtx4oHKwXoqUbMNqnHgAklnnuDon3XG5LJB35yPsXKv/8GK
      ke92wkI+s1Xkvsp8tg9BIY/7c6YK4SR07EWL+dB5qwctsWR2Q8z+/BKmTx9D99pm
      hnsjuNIXTF7BXrx3RX6BxZpH5Vzzh9nCwWKT/JCFqtwH7afNGGL7aMf+hdaiUg/Q
      SD05yRObioiO4iXDolsJOhrnbZvlzVHl1ZYxFJv0H6/Snc0BBA9Fl/3uj6ANpbjP
      eXF1SnJCqT87bj46r5NdVauzaRxAsIfqHroHK4UZ98X5LjGQFGvSqTvyjPBS4I1i
      s7VJU28ObuutHxIxSlH0ibn4HZqWmKWlTS652wIDAQABAoIBAGtPcUTTw2sJlR3x
      4k2wfAvLexkHNbZhBdKEa5JiO5mWPuLKwUiZEY2CU7Gd6csG3oqNWcm7/IjtC7dz
      xV8p4yp8T4yq7vQIJ93B80NqTLtBD2QTvG2RCMJEPMzJUObWxkVmyVpLQyZo7KOd
      KE/OM+aj94OUeEYLjRkSCScz1Gvq/qFG/nAy7KPCmN9JDHuhX26WHo2Rr1OnPNT/
      7diph0bB9F3b8gjjNTqXDrpdAqVOgR/PsjEBz6DMY+bdyMIn87q2yfmMexxRofN6
      LulpzSaa6Yup8N8H6PzVO6KAkQuf1aQRj0sMwGk1IZEnj6I0KbuHIZkw21Nc6sf2
      ESFySDECgYEA1PnCNn5tmLnwe62Ttmrzl20zIS3Me1gUVJ1NTfr6+ai0I9iMYU21
      5czuAjJPm9JKQF2vY8UAaCj2ZoObtHa/anb3xsCd8NXoM3iJq5JDoXI1ldz3Y+ad
      U/bZUg1DLRvAniTuXmw9iOTwTwPxlDIGq5k+wG2Xmi1lk7zH8ezr9BMCgYEA0gfk
      EhgcmPH8Z5cU3YYwOdt6HSJOM0OyN4k/5gnkv+HYVoJTj02gkrJmLr+mi1ugKj46
      7huYO9TVnrKP21tmbaSv1dp5hS3letVRIxSloEtVGXmmdvJvBRzDWos+G+KcvADi
      fFCz6w8v9NmO40CB7y/3SxTmSiSxDQeoi9LhDBkCgYEAsPgMWm25sfOnkY2NNUIv
      wT8bAlHlHQT2d8zx5H9NttBpR3P0ShJhuF8N0sNthSQ7ULrIN5YGHYcUH+DyLAWU
      TuomP3/kfa+xL7vUYb269tdJEYs4AkoppxBySoz8qenqpz422D0G8M6TpIS5Y5Qi
      GMrQ6uLl21YnlpiCaFOfSQMCgYEAmZxj1kgEQmhZrnn1LL/D7czz1vMMNrpAUhXz
      wg9iWmSXkU3oR1sDIceQrIhHCo2M6thwyU0tXjUft93pEQocM/zLDaGoVxtmRxxV
      J08mg8IVD3jFoyFUyWxsBIDqgAKRl38eJsXvkO+ep3mm49Z+Ma3nM+apN3j2dQ0w
      3HLzXaECgYBFLMEAboVFwi5+MZjGvqtpg2PVTisfuJy2eYnPwHs+AXUgi/xRNFjI
      YHEa7UBPb5TEPSzWImQpETi2P5ywcUYL1EbN/nqPWmjFnat8wVmJtV4sUpJhubF4
      Vqm9LxIWc1uQ1q1HDCejRIxIN3aSH+wgRS3Kcj8kCTIoXd1aERb04g==
      -----END RSA PRIVATE KEY-----
    '';
  };
    extraConfig = {
      gitlab = {
        email_reply_to = "gitlab-no-reply@example.com";
        default_projects_features = { builds = false; };
      };
    };
  };
}
