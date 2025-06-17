{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    font-awesome 
    jetbrains-mono
    nerd-fonts.noto
    nerd-fonts.hack
    noto-fonts
    noto-fonts-emoji
    #fira-sans
  ];
}
