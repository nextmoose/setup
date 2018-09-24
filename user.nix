{ config, pkgs, ... }:
{
  users.extraUsers.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    hashedPassword = "HASHED_PASSWORD";
    packages = [
    ];
    openssh.authorizedKeys.keys = [
      "AUTHORIZED_KEY_PUBLIC"
    ];
  };
}