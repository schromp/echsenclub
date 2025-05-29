{...}: {
  services = {
    sabnzbd = {
      enable = true;
      user = "jellyfin";
      group = "jellyfin";
    };

    sonarr = {
      enable = true;
      user = "jellyfin";
      group = "jellyfin";
      settings = {
        server = {
          port = 8090;
        };
      };
    };

    radarr = {
      enable = true;
      user = "jellyfin";
      group = "jellyfin";
      settings = {
        server = {
          port = 8093;
        };
      };
    };

    prowlarr = {
      enable = true;
      settings = {
        server = {
          urlbase = "prowlarr.echsen.club";
          port = 8092;
        };
      };
    };

    readarr = {
      enable = true;
      user = "jellyfin";
      group = "jellyfin";
      settings.server = {
        port = 8094;
      };
    };

    jellyseerr = {
      enable = true;
      port = 8091;
      openFirewall = true;
    };
  };
}
