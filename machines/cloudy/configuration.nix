{
  config,
  pkgs,
  clan-core,
  ...
}:
{
  imports = [
    ../../modules/shared.nix

    ../../modules/synapse-admin.nix

    ./disko.nix
    ./keycloak.nix
    ./nginx.nix
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9affda48-fb81-44cb-8737-e276777bcd1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9F63-2F1F";
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
        ];
      server = [ "1.1.1.1" ];
    };
  };

  networking.firewall.interfaces."nb-echsenclub".allowedUDPPorts = [
    53
    5353
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
