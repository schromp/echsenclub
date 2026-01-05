{
  clan-core,
  pkgs,
  config,
  ...
}:
{
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
      "jellyseerr.echsen.club" = {
        useACMEHost = "jellyseerr.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8091";
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
      # "pdf.echsen.club" = {
      #   useACMEHost = "pdf.echsen.club";
      #   forceSSL = true;
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:8100";
      #     proxyWebsockets = true;
      #   };
      # };
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
      "immich.echsen.club" = {
        useACMEHost = "immich.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://[::1]:2283";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
      "signoz.echsen.club" = {
        useACMEHost = "signoz.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };
      "git.echsen.club" = {
        useACMEHost = "git.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };
      "freshrss.echsen.club" = {
        useACMEHost = "freshrss.echsen.club";
        forceSSL = true;
      };
      "grocy.echsen.club" = {
        useACMEHost = "grocy.echsen.club";
        forceSSL = true;
      };
      "copyparty.echsen.club" = {
        useACMEHost = "copyparty.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3923";
          proxyWebsockets = true;
          extraConfig = ''
            auth_request /internal-auth;

            # 2. Extract the user identity from the IdP response headers
            # Assuming your IdP sends 'Remote-User'
            auth_request_set $auth_user $upstream_http_remote_user;
            
            # 3. Inject it into the request sent to Copyparty
            proxy_set_header X-Remote-User $auth_user;
            
            # Security: Clear the header from the incoming client request 
            # so they can't spoof it
            proxy_set_header X-Remote-User $auth_user; 
          '';
        };
        locations."/internal-auth" = {
            proxyPass = "http://127.0.0.1:9091/api/verify"; # Example: Authelia/Middleware port
            extraConfig = ''
              internal;
              proxy_pass_request_body off;
              proxy_set_header Content-Length "";
              proxy_set_header X-Original-URI $request_uri;
            '';
          };
      };
    };
  };
}
