{ config, pkgs, ... }:
{
  containers = {
    experiment = (import ./containers/experiment.nix);
    docker = (import ./containers/docker.nix);
    docker = (import ./containers/shopsafe.nix);
  };
}
