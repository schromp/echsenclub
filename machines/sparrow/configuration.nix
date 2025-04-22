{lib, ...}: {
  imports = [
    ../../modules/disko.nix
    ../../modules/shared.nix
  ];

  users.users.user.name = "lk";

  disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x50026b767b01bd9f";

  clan.core.networking.targetHost = "root@sparrow";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRat12+538VwG/IAv5R4AjdNYz/GATO7ULQnXtYC2HK lk@tower
    ''
  ];

  networking = {
    interfaces."enp0s31f6" = {
      ipv4.addresses = [{
        address = "192.168.178.2";
        prefixLength = 24;
      }];
    };
  };
}
