{ config, pkgs, ... }:

{
    # Hyprland
    programs.hyprland = {
        enable = true;
    };

    # Display Manager
    services.displayManager.ly.enable = true;

    # Wayland / Hyprland related apps
    environment.systemPackages = with pkgs; [
      # Wallpaper: swww
      #hyprpaper
      swww
      # Terminal Emulator: kitty
      kitty
      ghostty
      #alacritty
      # Notification Daemon: mako
      mako
      #libnotify
      # QT Wayland Support: qt5-wayland qt6-wayland
      qt5.qtwayland
      qt6.qtwayland
      # QT Theming: qt5ct qt6ct
      # qt5ct - has been renamed to libsForQt5.qt5ct
      libsForQt5.qt5ct
      qt6ct
      libsForQt5.qtstyleplugin-kvantum
      # Idle Manager: hypridle
      #swayidle
      hypridle
      # Screen Locker: hyprlock
      #swaylock-effects
      hyprlock
      # Logout Menu: wlogout
      wlogout
      # Clipboard Manager: cliphist
      wl-clipboard
      cliphist
      # App launcher : fuzzel
      #wofi
      fuzzel 
      # Bar: waybar
      waybar
      # Browser: vivaldi
      # firefox
      vivaldi
      # File manager
      nautilus
      # Brightness: brightnessctl
      brightnessctl
      # Playback Control: playerctl
      playerctl
      # Color Picker: hyprpicker
      hyprpicker
      # Screenshots: grim slurp swappy
      grim
      slurp
      swappy
      # Removable Media: udiskie
      udiskie
      # GTK Theming: nwg-look
      nwg-look
    ];

    # Enable GVfs for Nautilus and udiskie
    services.gvfs.enable = true;

    # Enable Polkit
    security.polkit.enable=true;
}
