{...}: {
  services.jellyfin = {
    enable = true;
    dataDir = "/srv/jellyfin";
  };
}
