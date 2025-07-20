{lib, ...}: {
  boot.loader.grub.efiSupport = lib.mkDefault true;
  boot.loader.grub.efiInstallAsRemovable = lib.mkDefault true;
  disko.devices = {
    disk = {
      "main" = {
        name = "main-09e0a9c5d7f74491b82768c41214d4cb";
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x50026b767b01bd9f";
        content = {
          type = "gpt";
          partitions = {
            "boot" = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 1;
            };
            "ESP" = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["nofail"];
              };
            };
            "root" = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                # format = "btrfs";
                # format = "bcachefs";
                mountpoint = "/";
              };
            };
          };
        };
      };
      sdb = {
        device = "/dev/disk/by-id/wwn-0x5000039fd3c4d3c4";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            storage = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                mountpoint = "/srv";
              };
            };
          };
        };
      };
    };
  };
}
