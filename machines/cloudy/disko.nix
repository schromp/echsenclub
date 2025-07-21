{lib, ...}: {
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_59179759";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            bios_boot = {
              type = "EF02";
              start = "1MiB";
              end = "2MiB";
              content = null;
            };
            esp = {
              type = "EF00";
              start = "2MiB";
              end = "514MiB";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["nofail"];
              };
            };
            root = {
              type = "8300";
              start = "514MiB";
              end = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = ["nofail"];
              };
            };
          };
        };
      };
    };
  };
}
