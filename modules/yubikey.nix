{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      yubikey-personalization-gui
      yubioath-flutter
    ];
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # To use the smart card mode (CCID) of Yubikey, you will need the PCSC-Lite daemon
  services.pcscd.enable = true;

}
