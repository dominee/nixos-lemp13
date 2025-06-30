{ config, pkgs, ... }:

{

   environment.systemPackages = with pkgs; [
	#yazi
	yaziPlugins.starship
	yaziPlugins.glow
  ];

   # Enable starhip prompt
   programs.starship.enable = true;

   programs.tmux = {
          enable = true;
          #mouse = true;
          baseIndex = 1;
          shortcut = "a";
          plugins = with pkgs; [
            tmuxPlugins.sensible
            tmuxPlugins.yank
            tmuxPlugins.vim-tmux-navigator
            tmuxPlugins.cpu
	    tmuxPlugins.catppuccin
         ];
	 extraConfig = ''
                set -g @catppuccin_flavor 'mocha'
                set -g @catppuccin_window_status_style 'rounded'
                set -g status-right-length 100
                set -g status-left-length 100
                set -g status-left ""
                set -g status-right "#{E:@catppuccin_status_application}"
                set -ag status-right "#{E:@catppuccin_status_session}"
                set -ag status-right "#{E:@catppuccin_status_uptime}"
              '';
 
         extraConfigBeforePlugins = ''
            # Enable color
            set-option -sa terminal-overrides ",xterm*:Tc"
          '';
        };
}
