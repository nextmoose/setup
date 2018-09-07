{ config, pkgs, ... }:
{
  containers = {
    experiment = (import ./containers/experiment.nix);
    browser = (import ./containers/browsers.nix);
  };
}
