{lib, ...}: {
  imports = [
    ../../modules/disko.nix
    ../../modules/shared.nix

    ./nextcloud.nix
    ./jellyfin.nix
    ./disko.nix
    ./nginx.nix
  ];

  users.users.user.name = "lk";

  disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x50026b767b01bd9f";
  boot.kernelModules = ["sg"];

  clan.core.networking.targetHost = "root@sparrow";

  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRat12+538VwG/IAv5R4AjdNYz/GATO7ULQnXtYC2HK lk@tower
    ''
  ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        53
        80
        443
        8096
      ];
      allowedUDPPorts = [
        53
      ];
    };

    nameservers = ["1.1.1.1"];

    interfaces."enp0s31f6" = {
      ipv4.addresses = [
        {
          address = "192.168.178.2";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = {
      address = "192.168.178.1";
      interface = "enp0s31f6";
    };
  };

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      # UseDns = true;
      # X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  # virtualisation.docker.storageDriver = "btrfs";
  # virtualisation.oci-containers.backend = "docker";
}
