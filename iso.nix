{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./iso.isolated.nix
  ];
  environment.systemPackages = [
    (import ./installer/default.nix  { inherit pkgs; })
  ];
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "AUTHORIZED_KEY_PUBLIC"
  ];
}