import <nixpkgs/nixos/tests/make-test.nix> {
  machine =
    { config, pkgs, ... }:
    {
    };
  testScript =
    ''
      $machine->start() &&
        $machine->waitForUnit("default.target");
        $machine->shutdown()
    '';
}