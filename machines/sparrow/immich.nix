{ ... }:
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
}
