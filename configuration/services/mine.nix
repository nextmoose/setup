{config, pkgs, ...}:

with pkgs.lib;

let

  cfg = config.environment

in

{
  options = {
    enable =
      mkOption {
        type = types.bool;
	default = false;
      };
  };
  config = mkIf cfg.enable(
    users.extraUsers.user = {
      isNormalUser = true;
      uid = 1100;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  );
};