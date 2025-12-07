{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    ../../modules/shared.nix

    ./postgres.nix
    ./nextcloud.nix
    ./jellyfin.nix
    ./audiobookshelf.nix
    ./disko.nix
    ./nginx.nix
    ./arr.nix
    ./k3s.nix
    ./kavita.nix
    ./immich.nix
    ./otelcol.nix
    ./forgejo.nix
  ];

  fileSystems."/srv" = {
    device = "UUID=42879296-884b-46ca-bbc3-0cf0bec3718e";
    fsType = "btrfs";
    options = [
      "defaults"
      "noatime"
    ];
  };

  boot.kernelModules = [ "sg" ];

  clan.core.networking.targetHost = "root@sparrow";

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
        6443 # K3s
        8011 # Netbird API
        8013
        8082
        8080
        8089 # sabnzbd
        8090 # Sonarr
        8093
        9092 # Prowlarr
        8096
        8097
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

  services.resolved = {
    enable = true;
    #   fallbackDns = ["1.1.1.1" "8.8.8.8"];
    dnssec = "false";
  };

  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
      # UseDns = true;
      # X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
    };
  };

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.nvidia.acceptLicense = true;
  hardware.nvidia.open = false;
  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };

  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
  };
  # virtualisation.docker.storageDriver = "btrfs";
  # virtualisation.oci-containers.backend = "docker";
}
