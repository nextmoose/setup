{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  environment.systemPackages = [
    pkgs.mkpasswd
    (import ./custom/installer/default.nix { inherit pkgs; })
  ];
  system.extraDependencies = [
    pkgs.chromium
    pkgs.emacs
    pkgs.gnupg
    pkgs.pass
    pkgs.git
    pkgs.mkpasswd
  ];
}