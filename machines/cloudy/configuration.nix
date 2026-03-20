{
  pkgs,
  lib,
  ...
}:
{
  clan.core.sops.defaultGroups = [ "admins" ];

  imports = [
    ./disko.nix
    ./keycloak.nix
    ./tangled.nix
    ./grafana.nix
    ./caddy.nix
    ./jellyswarm.nix
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
    ];
  };

  services.openssh.settings.PasswordAuthentication = false;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  services.matrix-synapse.settings = {
    max_upload_size = "100M";
  };

  services.dnsmasq = {
    enable = false;
    settings = {
      interface = "nb-echsenclub"; # when broken, remove this, update, add again, update again.
      # Also please fix this dns setup soon
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
          "/nextcloud.echsen.club/${sparrow}"
          "/rss.echsen.club/${sparrow}"
          "/immich.echsen.club/${sparrow}"
          "/signoz.echsen.club/${sparrow}"
          "/git.echsen.club/${sparrow}"
          "/freshrss.echsen.club/${sparrow}"
          "/grocy.echsen.club/${sparrow}"
          "/copyparty.echsen.club/${sparrow}"
          "/clickhouse.echsen.club/${sparrow}"
          "/maubot.echsen.club/${cloudy}"
          "/matrix-admin.echsen.club/${cloudy}"
        ];
      server = [ "1.1.1.1" ];
    };
  };

  services.resolved.enable = true;
}
