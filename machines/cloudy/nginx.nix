{ config, lib, ... }:
{
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
      "matrix.echsen.club" = {
        useACMEHost = "matrix.echsen.club";
        enableACME = lib.mkForce false;
      };
      "knot.echsen.club" = {
        useACMEHost = "knot.echsen.club";
        forceSSL = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://localhost:5555";
          proxyWebsockets = true;
        };
        locations."/events" = {
          proxyPass = "http://localhost:5555";
          proxyWebsockets = true;
        };
      };
      "spindle.echsen.club" = {
        useACMEHost = "spindle.echsen.club";
        forceSSL = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://localhost:5555";
          proxyWebsockets = true;
        };
        locations."/events" = {
          proxyPass = "http://localhost:5555";
          proxyWebsockets = true;
        };
      };
      "maubot.echsen.club" = {
        listenAddresses = [ "100.117.81.56" ]; # Only listen on the NetBird interface
        useACMEHost = "maubot.echsen.club";
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:29316";
          };
          "/_matrix/maubot/v1/logs" = {
            proxyPass = "http://localhost:29316";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header X-Forwarded-For $remote_addr;
            '';
          };
          "/_matrix/maubot" = {
            proxyPass = "http://localhost:29316";
            extraConfig = ''
              proxy_set_header X-Forwarded-For $remote_addr;
            '';
          };
        };
      };
      "netbird.echsen.club" = {
        forceSSL = true;
        useACMEHost = "netbird.echsen.club";
        extraConfig = ''
          proxy_set_header        X-Real-IP $remote_addr;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header        X-Scheme $scheme;
          proxy_set_header        X-Forwarded-Proto https;
          proxy_set_header        X-Forwarded-Host $host;
          grpc_set_header         X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
        locations = {
          "/api".proxyPass = "http://127.0.0.1:8011";

          "/management.ManagementService/".extraConfig = ''
            # This is necessary so that grpc connections do not get closed early
            # see https://stackoverflow.com/a/67805465
            client_body_timeout 1d;

            grpc_pass grpc://127.0.0.1:8011;
            grpc_read_timeout 1d;
            grpc_send_timeout 1d;
            grpc_socket_keepalive on;
          '';
        };
        locations."/signalexchange.SignalExchange/".extraConfig = ''
          # This is necessary so that grpc connections do not get closed early
          # see https://stackoverflow.com/a/67805465
          client_body_timeout 1d;

          grpc_pass grpc://127.0.0.1:8012;
          grpc_read_timeout 1d;
          grpc_send_timeout 1d;
          grpc_socket_keepalive on;
        '';
        locations."/relay".extraConfig = ''
          proxy_pass http://127.0.0.1:33080/relay;

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
      };
    };
  };
}
