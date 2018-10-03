with import <nixpkgs> {};
{
  pkgs.writeShellScriptBin "wifi" ''
    ${pkgs.networkmanager}/bin/nmcli device wifi connect "Richmond Sq Guest" password "guestwifi"
  '';
}