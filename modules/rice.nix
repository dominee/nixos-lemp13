{ config, pkgs, ... }:

{

   environment.systemPackages = with pkgs; [
	# tmux
	tmuxPlugins.catppuccin
	tmuxPlugins.cpu
	tmuxPlugins.vim-tmux-navigator
	tmuxPlugins.sensible
	tmuxPlugins.yank
	#yazi
	yaziPlugins.starship
	yaziPlugins.glow
  ];

   # Enable starhip prompt
   programs.starship.enable = true;

}
