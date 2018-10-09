{config, pkgs, ...}:
let installer = (import ./custom/installer/default.nix { inherit pkgs; });
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  programs.bash.shellInit = ''
    ${installer}/bin/installer
  '';
  environment.systemPackages = [
    ${installer}
  ];
}