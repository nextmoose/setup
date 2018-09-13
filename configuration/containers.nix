{ config, pkgs, ... }:
{
  containers = {
    browser = (import ./containers/browser.nix);
    experiment = (import ./containers/experiment.nix);
    docker = (import ./containers/docker.nix);
    shopsafe = (import ./containers/shopsafe.nix);
  };
}
