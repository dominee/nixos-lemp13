{ config, lib, pkgs, ... }:

{
  services.libinput.enable = true;
  users.users.dominee = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      tree
    ];
  };
}
