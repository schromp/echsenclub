{
  clan-core,
  pkgs,
  config,
  ...
}: {
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
      "audiobookshelf.echsen.club" = {
        useACMEHost = "audiobookshelf.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://0.0.0.0:8097";
          proxyWebsockets = true;
        };
      };
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
        http2 = true;
        locations."/api" = {
          proxyPass = "http://127.0.0.1:8011";
          proxyWebsockets = true;
        };
        locations."/management.ManagementService/" = {
          proxyPass = "http://127.0.0.1:8011";
          proxyWebsockets = true;
          extraConfig = ''
            grpc_pass grpc://localhost:33073;
            grpc_read_timeout 1d;
            grpc_send_timeout 1d;
            grpc_socket_keepalive on;
          '';
        };
        locations."/signalexchange.SignalExchange/" = {
          proxyPass = "http://127.0.0.1:8012";
          proxyWebsockets = true;
          extraConfig = ''
                if ($http_content_type = "application/grpc") {
                    grpc_pass grpc://192.168.178.2:10000;
                }
            grpc_read_timeout 300s;
            grpc_send_timeout 300s;
            grpc_socket_keepalive on;
            grpc_set_header X-Forwarded-For $proxy_add_x_forwarded_for; #helps getting the correct IP through npm to the server
          '';
        };
        # NOTE: the dashboard is configured through the nix module
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
      "zitadel.echsen.club" = {
        useACMEHost = "zitadel.echsen.club";
        forceSSL = true;
        http2 = true;
        locations."/" = {
          extraConfig = ''
            grpc_pass grpc://127.0.0.1:8082;
            grpc_set_header Host $host;
          '';
        };
      };
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

  clan.core.vars.generators = {
    "acme-cloudflare-api-key" = {
      prompts.cf-api-key.description = "The cloudflare api key";
      prompts.cf-api-key.type = "hidden";
      prompts.cf-api-key.persist = false;

      prompts.cf-email.description = "The email of the cf account";
      prompts.cf-email.persist = false;

      script = ''
        {
          printf "CF_DNS_API_TOKEN="; cat "$prompts/cf-api-key"; echo
          printf "CF_ZONE_API_TOKEN="; cat "$prompts/cf-api-key"; echo
          printf "CF_API_EMAIL=";  cat "$prompts/cf-email";  echo
        } > "$out/acme-cf-env"
      '';

      files.acme-cf-env = {
        secret = true;
      };
      share = true;
    };
  };
}
