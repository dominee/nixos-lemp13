{ config, lib, pkgs, ... }:
{
  imports =
      ./hardware-configuration.nix
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;
  boot.initrd.luks.devices = {
      root = {
        # lsblk -f | grep nvme0n1p2
        device = "/dev/disk/by-uuid/ab47ed2f-4f99-4ce5-979b-ecf9ff24e54d";
        allowDiscards = true;
        preLVM = true;
      };
  };
  networking.hostName = "gh0st"; # Define your hostname.
  networking.networkmanager.enable = true;
  #networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  time.timeZone = "Europe/Bratislava";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.libinput.enable = true;
  users.users.dominee = {
    isNormalUser = true;
    # Run mkpasswd -m sha-512 to generate it
    hashedPassword = "$6$...";
    packages = with pkgs; [
      tree
    ];
  };
  environment.systemPackages = with pkgs; [
     wget
     git
     curl
   ];
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
}
