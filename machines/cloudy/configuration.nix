{
  config,
  pkgs,
  clan-core,
  lib,
  ...
}:
{
  imports = [
    ../../modules/shared.nix

    ../../modules/synapse-admin.nix

    ./disko.nix
    ./keycloak.nix
    ./nginx.nix
    ./maubot.nix
    ./tangled.nix
  ];

  fileSystems."/" = {
    device = lib.mkForce "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_59179759-part3";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = lib.mkForce "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_59179759-part2";
    fsType = "vfat";
  };

  # Set this for clan commands use ssh i.e. `clan machines update`
  # If you change the hostname, you need to update this line to root@<new-hostname>
  # This only works however if you have avahi running on your admin machine else use IP
  clan.core.networking.targetHost = "root@cloudy";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      53
      80
      443

      # 33080 # netbird relay
    ];
    allowedUDPPorts = [
      3478
      12312 # temp
    ];
    allowedUDPPortRanges = [
      {
        from = 49152;
        to = 65535;
      }
    ];
  };

  # users.users.root.openssh.authorizedKeys.keys = [
  #   ''
  #     ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRat12+538VwG/IAv5R4AjdNYz/GATO7ULQnXtYC2HK lk@tower
  #   ''
  # ];

  services.openssh.settings.PasswordAuthentication = false;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  services.matrix-synapse.settings = {
    max_upload_size = "100M";
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "nb-echsenclub";
      bind-interfaces = true;
      port = 5353;
      address =
        let
          cloudy = "100.117.81.56";
          sparrow = "100.117.12.69";
        in
        [
          "/jellyseerr.echsen.club/${sparrow}"
          "/jellyfin.echsen.club/${sparrow}"
          "/radarr.echsen.club/${sparrow}"
          "/sonarr.echsen.club/${sparrow}"
          "/prowlarr.echsen.club/${sparrow}"
          "/sabnzbd.echsen.club/${sparrow}"
          "/pdf.echsen.club/${sparrow}"
          "/kavita.echsen.club/${sparrow}"
          "/audiobookshelf.echsen.club/${sparrow}"
          "/nextcloud.echsen.club/${sparrow}"
          "/rss.echsen.club/${sparrow}"
          "/immich.echsen.club/${sparrow}"
          "/signoz.echsen.club/${sparrow}"
          "/git.echsen.club/${sparrow}"
          "/grocy.echsen.club/${sparrow}"
          "/maubot.echsen.club/${cloudy}"
          "/matrix-admin.echsen.club/${cloudy}"
        ];
      server = [ "1.1.1.1" ];
    };
  };

  networking.firewall.interfaces."nb-echsenclub".allowedUDPPorts = [
    53
    5353
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  # services.resolved.enable = false;

  # services.netbird = {
  #   server.coturn = {
  #     enable = true;
  #     domain = "coturn-cloudy.netbird.echsen.club";
  #     passwordFile = config.clan.core.vars.generators."netbird-turn-cloudy-password".files."turn-cloudy-password".path;
  #     useAcmeCertificates = true;
  #   };
  # };
}
