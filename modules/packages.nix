{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      wget
      git
      curl
      btop
      fzf
      grc
      neofetch
      mc
      tmux
      yazi
      spotify-player
    ];
}
