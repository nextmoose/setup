# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  environment.variables.FOO="bar";
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "hello" ''
      echo hello world
    '')
  ];
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuf5Cg+E6+TbnmJDtd2EvzRy1EnLj48lCFOShlGX67gSgPpOyYXVZCbHp0Tg1YRQjd8WWVjE0mxW1CNjIdjthruWR+17S6WyXEIDQTarL71QaxwgHMBtTnsVmd1brzj8FdhVeyjb1O1DaKy46XGO6f7xBiGr+FhdQ2lhVeDpBjh/Edx4drMks9wOv5df0+q3PFEB3Lbruv7M2xJLdfCkb0OPkIWaa3Ft+3nsoM6Mu8CVL/q7d8jKvcIIybmYueVqxt+78jGJFjWRyWSfbJhFlj5tsIvOpz0P0Fh7Rrw+uguxUoI/CHPT6RCH2lqnBd62mfn6kzsLStzU3v0QFEDRHx"
  ];
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.ip4 = [{
      address = "64.137.201.46";
      prefixLength = 24;
    }];
    defaultGateway = "64.137.201.1";
  };
}