{
  clan-core,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../shared/cloudflare-api.nix
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "jellyfin.echsen.club" = {
        useACMEHost = "jellyfin.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
      "nextcloud.echsen.club" = {
        useACMEHost = "nextcloud.echsen.club";
        forceSSL = true;
      };
      "audiobookshelf.echsen.club" = {
        useACMEHost = "audiobookshelf.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8097";
          proxyWebsockets = true;
        };
      };
      "sabnzbd.echsen.club" = {
        useACMEHost = "sabnzbd.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8089";
        };
      };
      "sonarr.echsen.club" = {
        useACMEHost = "sonarr.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8090";
        };
      };
      "radarr.echsen.club" = {
        useACMEHost = "radarr.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8093";
        };
      };
      "prowlarr.echsen.club" = {
        useACMEHost = "prowlarr.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8092";
        };
      };
      "readarr.echsen.club" = {
        useACMEHost = "readarr.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8094";
        };
      };
      "jellyseerr.echsen.club" = {
        useACMEHost = "jellyseerr.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8091";
        };
      };
      "arm.echsen.club" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:28982";
          proxyWebsockets = true;
        };
      };
      # "signal-sparrow.netbird.echsen.club" = {
      #   useACMEHost = "signal-sparrow.netbird.echsen.club";
      #   forceSSL = true;
      #   http2 = true;
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:8013";
      #     proxyWebsockets = true;
      #   };
      # };
      "pdf.echsen.club" = {
        useACMEHost = "pdf.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8100";
          proxyWebsockets = true;
        };
      };
      "kavita.echsen.club" = {
        useACMEHost = "kavita.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8101";
          proxyWebsockets = true;
        };
      };
      "rss.echsen.club" = {
        useACMEHost = "rss.echsen.club";
        forceSSL = true;
      };
    };
  };
}
