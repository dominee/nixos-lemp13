{ config, pkgs, ... }:

{

   environment.systemPackages = with pkgs; [
  	catppuccin-gtk
	catppuccin-kvantum
	catppuccin-cursors
	catppuccin-qt5ct
	(catppuccin-gtk.override {
    		accents = [ "blue" ]; # [ "blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow" ]
    		size = "compact"; # [ "standard" "compact" ]
    		tweaks = [ "rimless" "black" ]; # [ "black" "rimless" "normal" ];
    		variant = "mocha"; # [ "latte" "frappe" "macchiato" "mocha" ]
  	})
  ];
}
