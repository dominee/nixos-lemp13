{ config, pkgs, ... }:

{
  pkgs.catppuccin-gtk.override {
    accents = [ "blue" ]; # [ "blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow" ]
    size = "compact"; # [ "standard" "compact" ]
    tweaks = [ "rimless" "black" ]; # [ "black" "rimless" "normal" ];
    variant = "mocha"; # [ "latte" "frappe" "macchiato" "mocha" ]
  }
}
