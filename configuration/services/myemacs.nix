{config, lib, pkgs, ...}:

with lib;

let

  cfg = config.programs.myemacs;

in

{
  options.programs.myemacs = {
    enable =
      mkOption {
        type = types.bool;
	default = false;
	description = ''This option enables myemacs'';
  };
};