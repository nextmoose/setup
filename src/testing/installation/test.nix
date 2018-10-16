import <nixpkgs/nixos/tests/make-test.nix> {
  machine =
    { config, pkgs, ... }:
    {
      config.virtualisation.diskImage = "/tmp/nixos-18.03.133245.d16a7abceb7-x86_64-linux.iso";
      config.virtualisation.qemu.options = [
        "-cdrom /tmp/nixos-18.03.133245.d16a7abceb7-x86_64-linux.iso"
      ];
      config.virtualisation.emptyDiskImages = [ 10000 10000 10000 ];
    };
  testScript =
    ''
      $machine->start();
      $machine->execute("sleep 20s");
      $machine->screenshot("20s");
      $machine->shutdown();
    '';
}