{ config, pkgs, ... }:
{
  containers = {
    experiment = (import ./containers/experiment.nix { inherit pkgs; });
  };
}
