{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./iso-ssh.nix
  ];
  environment.systemPackages = [
    (import ./custom/my-install/default.nix  { inherit pkgs; })
  ];
}