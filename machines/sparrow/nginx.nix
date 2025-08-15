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
      # "audiobookshelf.echsen.club" = {
      #   useACMEHost = "audiobookshelf.echsen.club";
      #   forceSSL = true;
      #   locations."/" = {
      #     proxyPass = "http://0.0.0.0:8097";
      #     proxyWebsockets = true;
      #   };
      # };
      "sabnzbd.echsen.club" = {
        useACMEHost = "sabnzbd.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://192.168.178.2:8089"; # FIX:
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
      "netbird.echsen.club" = {
        useACMEHost = "netbird.echsen.club";
        forceSSL = true;
        locations."/api" = {
          proxyPass = "http://127.0.0.1:8011";
        };
        locations."/management.ManagementService/" = {
          proxyPass = "http://127.0.0.1:8011";
          proxyWebsockets = true;
          extraConfig = ''
            client_body_timeout 1d;

            grpc_pass grpc://127.0.0.1:8011;
            grpc_read_timeout 1d;
            grpc_send_timeout 1d;
            grpc_socket_keepalive on;
          '';
        };
        locations."/signalexchange.SignalExchange/" = {
          proxyPass = "http://127.0.0.1:8012";
          proxyWebsockets = true;
          extraConfig = ''
            client_body_timeout 1d;

            grpc_pass grpc://192.168.178.2:8012;
            grpc_read_timeout 1d;
            grpc_send_timeout 1d;
            grpc_socket_keepalive on;
          '';
        };
        locations."/relay".extraConfig = ''
          proxy_pass http://192.168.178:33080;

          # WebSocket support
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";

          # Timeout settings
          proxy_read_timeout 3600s;
          proxy_send_timeout 3600s;
          proxy_connect_timeout 60s;

          # Handle upstream errors
          proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        '';
        # # NOTE: the dashboard is configured through the nix module
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
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "server@echsen.club";

    certs."zitadel.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."netbird.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."turn-sparrow.netbird.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."jellyfin.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."audiobookshelf.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."jellyseerr.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."sonarr.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."radarr.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."sabnzbd.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."prowlarr.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."readarr.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."pdf.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."kavita.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
  };
}
