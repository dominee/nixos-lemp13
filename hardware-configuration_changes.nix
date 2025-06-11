{ config, lib, pkgs, ... }:

{

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/98e0d3e3-d66e-440c-82af-4a2ccbc3bfd4";
      fsType = "btrfs";
      options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/98e0d3e3-d66e-440c-82af-4a2ccbc3bfd4";
      fsType = "btrfs";
      options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/98e0d3e3-d66e-440c-82af-4a2ccbc3bfd4";
      fsType = "btrfs";
      options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
    };

  fileSystems."/etc/nixos" =
    { device = "/dev/disk/by-uuid/98e0d3e3-d66e-440c-82af-4a2ccbc3bfd4";
      fsType = "btrfs";
      options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/98e0d3e3-d66e-440c-82af-4a2ccbc3bfd4";
      fsType = "btrfs";
      options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C91D-901F";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/dev/disk/by-uuid/61c80561-8301-4952-b124-278544929d02"; } ];

}
