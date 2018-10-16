import <nixpkgs/nixos/tests/make-test.nix> {
  machine =
    { config, pkgs, ... }:
    {
       config.virtualisation.diskImage = "./nixos.qcow2";
       config.virtualisation.emptyDiskImages = [ 1000 1000 1000 ];
       config.virtualisation.qemu.options = [
        "-cdrom /nix/store/4xlkspgrqhygm7byflvadwd5rdknph5s-nixos-18.03.133245.d16a7abceb7-x86_64-linux.iso/iso/nixos-18.03.133245.d16a7abceb7-x86_64-linux.iso"
      ];
    };
  testScript =
    ''
      $machine->start();
      $machine->waitForUnit("default.target");
      $machine->succeed("ls -lah /dev");
      $machine->shutdown();
    '';
}