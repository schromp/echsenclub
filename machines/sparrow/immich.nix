{ ... }:
{
  services.immich = {
    enable = true;
    port = 2283;
    machine-learning = {
      enable = true;
    };
    mediaLocation = "/srv/media/immich";
    accelerationDevices = null;
    settings = null;
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
}
