{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/disko.nix
    ../../modules/shared.nix

    ./postgres.nix
    ./zitadel.nix
    ./netbird.nix
    ./nextcloud.nix
    ./hydroxide.nix
    ./jellyfin.nix
    ./disko.nix
    ./nginx.nix
    ./arr.nix
    # ./maubot.nix
    # ./n8n.nix
    # ./bar-assistant.nix
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
        1025
        5433
        8011 # Netbird API
        8013
        8082
        8089 # sabnzbd
        8090 # Sonarr
        9092 # Prowlarr
        8096
        9091
        10000 # Netbird Signal
        33073 # Netbird Management
      ];
      allowedUDPPorts = [
        53
      ];
    };

    # nameservers = ["192.168.178.3"];

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

  services.resolved.enable = false;

  environment.etc."resolv.conf".text = ''
    nameserver 192.168.178.3
  '';

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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16" # This is needed for mautrix
  ];
  # nixpkgs.config.nvidia.acceptLicense = true;
  hardware.nvidia.open = false;
  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [nvidia-vaapi-driver];
  };

  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
  };
  # virtualisation.docker.storageDriver = "btrfs";
  # virtualisation.oci-containers.backend = "docker";
}
