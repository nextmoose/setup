{ config, pkgs, ... }:
{
  users.users.root.openssh.authorizedKeys.keys = [
  ];
}