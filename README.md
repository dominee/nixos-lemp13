# nixos-lemp13

Setup of `NixOS 25.05 (Warbler)` with disk encryption with LUKS2 on LVM and BTRFS.
Home-manager will not be used in this setup, instead `stow` managed dotfiles wll be used from [nixosdots](https://github.com/dominee/nixosdots) repo.


## NixOS install

Boot from the USB stick and setup networking with SSH to complete the install from another computer.

```sh
# Find your interface, in my case `wlp0s20f3`
iwconfig

# Generate a config
wpa_passphrase SSID 'PASSWORD' | sudo tee /etc/wpa_supplicant.conf

# Run the `wpa_supplicant` manually , not via `systemctl start wpa_supplicant`
sudo wpa_supplicant -c /etc/wpa_supplicant.conf -B -i wlp0s20f3

# Get IP address
ip a

# Start sshd
sudo systemctl start sshd

# generate a password for the user to login
passwd
```
### Partitioning

```
NAME             MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
nvme0n1          259:0    0 931.5G  0 disk
├─nvme0n1p1      259:1    0   512M  0 part  /boot/efi
└─nvme0n1p2      259:2    0   931G  0 part
  └─crypto-root  254:0    0   931G  0 crypt
    ├─vg-swap    254:1    0    40G  0 lvm   [SWAP]
    └─vg-root    254:2    0   891G  0 lvm   /
```

The only unencrypted partition is `nvme0n1p1`, which is mounted on `/boot/efi`. But rest of `/boot` is encrypted along with swap and root. 

Use Use `gdisk` to partition the drives

```sh
$ sudo gdisk /dev/nvme0n1
```

* `d` Delete existing partition tables, or use `wipefs -a /dev/nvme0n1`
* `o` Create partition table
* `n` Create new partition of size 550M and of type `ef00`
* `n` Create another partition of type `8300` and use remainig space
* `p` Show what gdisk will write
* `w` Write to disk an exit

The final layout should look like this.

```
Number  Start (sector)    End (sector)  Size       Code  Name
   1            4096         1052671   512.0 MiB   EF00  EFI
   2         1052672      1953525127   931.0 GiB   8300  Linux filesystem
```

And `lsblk` like this.

```
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme0n1     259:0    0 931.5G  0 disk
├─nvme0n1p1 259:3    0   512M  0 part
└─nvme0n1p2 259:4    0   931G  0 part

```

> All the commands below in this document require root privileges so either use `sudo` or run them in a root session `sudo su`.

## Setup LUKS

Encrypt the drive with LUKS2:

```sh
cryptsetup --verify-passphrase -v luksFormat --type=luks2 /dev/nvme0n1p2
cryptsetup open nvme0n1p2 crypt-root
```

## Setup LVM

This setup uses an encrypted swap of 40G to match the RAM available. It will be used as a backup to `zram`.  You can skip it if you like.

```sh
pvcreate /dev/mapper/crypt-root
vgcreate lvm /dev/mapper/crypt-root

lvcreate --size 40G --name swap lvm
lvcreate --extents 100%FREE --name root lvm
```

At this point `lsblk` should look like this.

```
NAME           MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
nvme0n1        259:0    0 931.5G  0 disk
├─nvme0n1p1    259:1    0   512M  0 part
└─nvme0n1p2    259:2    0   931G  0 part
  └─crypt-root 254:1    0   931G  0 crypt
    ├─lvm-swap 254:2    0    40G  0 lvm
    └─lvm-root 254:3    0   891G  0 lvm
```

## Setup FS

**Boot**

```sh
mkfs.vfat -n EFI -F 32 /dev/nvme0n1p1
```

**Swap**

```sh
mkswap /dev/lvm/swap
swapon /dev/lvm/swap
```

**Root**

```sh
mkfs.btrfs -L NixOS /dev/lvm/root
mount -t btrfs /dev/lvm/root /mnt
```

Mount partitions and create btrfs subvolumes:

```sh
# Exports BTRFS mount options
export BTRFS_OPT=rw,noatime,discard=async,compress-force=zstd,space_cache=v2,commit=120
# Mount root
mount -t btrfs -o $BTRFS_OPT /dev/lvm/root /mnt
# Create subvolumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@nixos-config
btrfs subvolume create /mnt/@log
# Umount and remount with subvolumes
umount /mnt
mount -o $BTRFS_OPT,subvol=@ /dev/lvm/root /mnt
# Create mountpoints
mkdir /mnt/home
mkdir /mnt/nix
mkdir -p /mnt/etc/nixos
mkdir -p /mnt/var/log

mount -o $BTRFS_OPT,subvol=@home /dev/lvm/root /mnt/home/
mount -o $BTRFS_OPT,subvol=@nix /dev/lvm/root /mnt/nix/
mount -o $BTRFS_OPT,subvol=@nixos-config /dev/lvm/root /mnt/etc/nixos/
mount -o $BTRFS_OPT,subvol=@log /dev/lvm/root /mnt/var/log

# Mount boot partition
mkdir -p /mnt/boot/
mount -o rw,noatime /dev/nvme0n1p1 /mnt/boot/
```



## NixOS config

Generate NixOS configuration files:

```sh
nixos-generate-config --root /mnt
```

Check disk UUIDs using `lsblk -f`.


```
NAME           FSTYPE      FSVER            LABEL                      UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
nvme0n1
├─nvme0n1p1    vfat        FAT32            EFI                        58D6-8CFC                                 511M     0% /mnt/boot
└─nvme0n1p2    crypto_LUKS 2                                           ab47ed2f-4f99-4ce5-979b-ecf9ff24e54d
  └─crypt-root LVM2_member LVM2 001                                    snWCfs-sFmY-20P1-FZ9A-j1ST-c57n-ODpWq4
    ├─lvm-swap swap        1                                           2681194f-6e6e-4b15-9817-fecfa7a107a4                  [SWAP]
    └─lvm-root btrfs                        NixOS                      2e4c65c4-6d57-42cd-92e6-9ece8fd70032      889G     0% /mnt/var/log
                                                                                                                             /mnt/etc/nixos
                                                                                                                             /mnt/nix
                                                                                                                             /mnt/home
                                                                                                                             /mnt
```


Changes related to `/mnt/etc/nixos/hardware-configuration.nix`. As the `nixos-generate-config` with all the mounted partitions, subvolumes and swap, the configuration should contain all filesystems with correct UUIDs.
The only part left to change re mount options.

```
options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
```

Changes related to `/etc/nixos/configuration.nix`, to create a minimalistic install.

```
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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
        # Find this hash use lsblk -f. It's the UUID of nvme0n1p2.
        device = "/dev/disk/by-uuid/ab47ed2f-4f99-4ce5-979b-ecf9ff24e54d";
        allowDiscards = true;
        preLVM = true;
      };
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}
```


## NixOS Install

Finally install the system and then `poweroff`/`reboot`.

```sh
nixos-install --root /mnt --cores 0
```

## Sources
* [NixOS Wiki /  Full Disk Encryption](https://nixos.wiki/wiki/Full_Disk_Encryption)
* [NixOS install with encrypted /boot /root with single password unlock](https://gist.github.com/ladinu/bfebdd90a5afd45dec811296016b2a3f)
* [Encypted LUKS LVM Btrfs Root with Opt-in State on NixOS](https://gist.github.com/hadilq/a491ca53076f38201a8aa48a0c6afef5)
* [NixOS installation with: Full Disk Encryption using LUKS2, BTRFS filesystem, systemd-boot](https://gist.github.com/Le0xFF/21942ab1a865f19f074f13072377126b)

