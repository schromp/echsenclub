{ config, lib, ... }:
{
  services.immich = {
    enable = true;
    port = 2283;
    machine-learning = {
      enable = true;
    };
    mediaLocation = "/srv/media/immich";
    accelerationDevices = [
      "/dev/nvidia0"
      "/dev/nvidiactl"
      "/dev/nvidia-uvm"
    ];
    settings = null;
  };

  users.users.immich = {
    home = "/var/cache/immich";
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  clan.core.state.immich = {
    folders = [
      "/srv/media/immich/upload"
      "/srv/media/immich/library"
      "/srv/media/immich/profile"
      "/srv/media/immich/backups"
    ];

    preBackupScript = ''
      export PATH=${lib.makeBinPath [ config.systemd.package ]}

      systemctl stop immich-machine-learning.service
      systemctl stop immich-server.service
    '';
    postBackupScript = ''
      export PATH=${lib.makeBinPath [ config.systemd.package ]}

      systemctl start immich-server.service
      systemctl start immich-machine-learning.service
    '';
  };
}
