{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  isoImage.includeSystemBuildDependencies = true;
  environment.systemPackages = [
    pkgs.sudo
    pkgs.mkpasswd
    (import ./custom/installer/default.nix { inherit pkgs; })
    pkgs.chromium
    pkgs.emacs
    pkgs.gnupg
    pkgs.pass
    pkgs.git
    pkgs.mkpasswd
  ];
  system.extraDependencies = [
    pkgs.sudo
    pkgs.chromium
    pkgs.emacs
    pkgs.gnupg
    pkgs.pass
    pkgs.git
    pkgs.mkpasswd
  ];
}