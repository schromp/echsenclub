{pkgs, ...}: {
  services.jellyfin = {
    enable = true;
    dataDir = "/srv/jellyfin";
  };

  environment.systemPackages = with pkgs; [
    jellyfin-ffmpeg
  ];
}
