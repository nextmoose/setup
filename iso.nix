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
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSPWu9I329zI6FrHQzZPLOanblYG1yMpHVXvgH9jHuYYaUNYOWD+8BHaoHzfSbdAiIyWy9149/t1LaXSr+6Tx+rr+8AS4zUkY4ngnjsUicrhqamMsr0Yr6Jk8xrNMcjqxd/Nmk0yjdclgxZ7BBWDz9rncr2e3Fs8DiwxkWlcWM/qFMZs/E81PQXEv1/elh/fU0TaAAhYC7dIae532eRAsa4pAw+oIixg15fRc5isrOeB/5LaIAtjF5tcYD2hx0FpMGxklYxaiZdUhCbqdHJB+bVw1zeIs8/4t8P00TnMAC1a72oZJUW5sMCq0fkEzh2uZ4WeM6zX4pYOYzQ0SHt6Ol"
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