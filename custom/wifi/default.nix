with import <nixpkgs> {};
let
  myScript =   pkgs.writeShellScriptBin "wifi" ''
    ${pkgs.networkmanager}/bin/nmcli device wifi connect "Richmond Sq Guest" password "guestwifi"
  '';
in
stdenv.mkDerivation rec {
  name = "wifi";
  buildInputs = [ myScript pkgs.networkmanager ];
}