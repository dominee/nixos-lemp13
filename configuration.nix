{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Source changes related to FS configuration
      ./hardware-configuration_changes.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS config
  boot.initrd.luks.devices = {
      root = {
        # Use https://nixos.wiki/wiki/Full_Disk_Encryption
        # Find this hash use lsblk -f. It's the UUID of nvme0n1p2
        device = "/dev/disk/by-uuid/TO find this hash use lsblk -f. It's the UUID of nvme0n1p2";
        allowDiscards = true;
        preLVM = true;
      };
  };

  networking.hostName = "gh0st"; # Define your hostname.
  networking.networkmanager.enable = false;
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # Set your time zone.
  timeZone = "Europe/Bratislava";
  
  # No Xserver.
  services.xserver.enable = false;
    
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dominee = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "Run mkpasswd -m sha-512 to generate it";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim git mkpasswd curl btop
  ];
 
  
  system.stateVersion = "25.05"; # Did you read the comment?

}
