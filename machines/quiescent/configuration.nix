{nixos-hardware, ...}: {
  imports = [
    ../../modules/shared.nix
    # nixos-hardware.nixosModules.raspberry-pi-3

    ./hardware-configuration.nix
  ];

  users.users.user.name = "lk";

  clan.core.networking.targetHost = "root@quiescent";


  # users.users.root.initialPassword = "1234";
  users.users.root.openssh.authorizedKeys.keys = [
    ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRat12+538VwG/IAv5R4AjdNYz/GATO7ULQnXtYC2HK lk@tower
    ''
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  image.modules.sd-card = {
    disabledModules = [
      ./hardware-configuration.nix
    ];
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        53
        80
        3000
        443
      ];
      allowedUDPPorts = [
        53
      ];
    };

    nameservers = ["1.1.1.1"];

    interfaces."enu1u1" = {
      ipv4.addresses = [
        {
          address = "192.168.178.3";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = {
      address = "192.168.178.1";
      interface = "enu1u1";
    };
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  services.adguardhome = {
    enable = true;
    allowDHCP = false;
    mutableSettings = true;
    port = 80;
    settings = {};
  };

}
