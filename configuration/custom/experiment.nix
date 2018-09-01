with import <nixpkgs> {};

pkgs.writeShellScriptBin "whatIsMyIp" ''
    ${pkgs.curl}/bin/curl http://httpbin.org/get \
      | ${pkgs.jq}/bin/jq --raw-output .origin
  '';

