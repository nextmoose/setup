{ config, pkgs, ... }:
{
  containers = {
    experiment = (import ./containers/experiment.nix);
    docker = (import ./containers/docker.nix);
    shopsafe = (import ./containers/shopsafe.nix);
  };
}
