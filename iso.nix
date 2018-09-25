{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./user.nix
  ];
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "US/Eastern";
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraUsers.myuser.extraGroups = ["vboxusers"];
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.libinput.enable = true;
  security.sudo.wheelNeedsPassword = false;
  environment.systemPackages = [
    pkgs.sudo
    (import ./installer/default.nix  { inherit pkgs; })
  ];
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.mutableUsers = false;
}