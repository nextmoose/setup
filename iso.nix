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
    "ID_RSA.PUB"
  ];
  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [{
      address = "64.137.201.46";
      prefixLength = 24;
    }];
    defaultGateway = "64.137.201.1";
  };
}