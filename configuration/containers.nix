{ config, pkgs, ... }:
{
  containers = {
    experiment = (input ./containers/experiment.nix);
  };
}
