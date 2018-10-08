{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  programs.bash.shellInit = ''
    wpa_supplicant -B -i wlo1 -c <(wpa_passphrase 'Richmond Sq Guest' 'guestwifi')
  '';
  environment.systemPackages = [
    (import ./installer/src/custom/wifi2/default.nix { inherit pkgs; })
    (import ./installer/default.nix  { inherit pkgs; })
  ];
}