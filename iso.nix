{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./iso.isolated.nix
  ];
  networking = {
    wireless.enable = true;
    useDHCP = true;
  };
  environment.systemPackages = [
    pkgs.networkmanager
    (import ./installer/src/custom/wifi/default.nix { inherit pkgs; })
    (import ./installer/src/custom/wifi2/default.nix { inherit pkgs; })
    (import ./installer/default.nix  { inherit pkgs; })
  ];
}