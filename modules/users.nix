{ config, lib, pkgs, ... }:

  services.libinput.enable = true;
  users.users.dominee = {
    isNormalUser = true;
    # Run mkpasswd -m sha-512 to generate it
    hashedPassword = "$6$...";
    programs.zsh.enable = true;
    #shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      tree
    ];
  };
