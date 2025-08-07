{config, ...}: {
  imports = [
    ../../shared/cloudflare-api.nix
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "sso.echsen.club" = {
        useACMEHost = "sso.echsen.club";
        forceSSL = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://localhost:8080";
        };
      };
      "sso-admin.echsen.club" = {
        useACMEHost = "sso-admin.echsen.club";
        forceSSL = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://localhost:8080";
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
        # NOTE: the dashboard is configured through the nix module
      };
    };
  };

  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "server@echsen.club";
  #
  #   certs."zitadel.echsen.club" = {
  #     group = "nginx";
  #     dnsProvider = "cloudflare";
  #     environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
  #   };
  # };
}
