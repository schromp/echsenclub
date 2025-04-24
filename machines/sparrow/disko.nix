{...}: {
  disko.devices = {
    disk = {
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
