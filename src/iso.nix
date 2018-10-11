{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  isoImage.includeSystemBuildDependencies = true;
  isoImage.storeContents = [
    (import ./custom/installer/default.nix { inherit pkgs; })
    (import ./custom/installer/src/configuration.nix { inherit pkgs; })
  ];
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