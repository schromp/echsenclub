{ config, ... }:
{
  services.caddy = {
    enable = true;
    email = "server@echsen.club";
    # TODO: bind all proxies to lldap to netbird interface
    virtualHosts = {
      # "lldap-admin.echsen.club".extraConfig = ''
      #   reverse_proxy http://127.0.0.1:17170
      # '';
      # "lldap.echsen.club".extraConfig = ''
      #   reverse_proxy http://127.0.0.1:3890
      # '';
      "sso2.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:9091
      '';
      "netbird2.echsen.club" = {
        extraConfig = ''
          root * ${config.services.netbird.server.dashboard.finalDrv}

          # Relay (WebSocket)
          handle /relay* {
            reverse_proxy localhost:33080
          }

          # Signal WebSocket
          #handle /ws-proxy/signal* {
          #reverse_proxy netbird-signal:80
          #}

          # Signal gRPC (h2c for plaintext HTTP/2)
          handle /signalexchange.SignalExchange/* {
            reverse_proxy h2c://localhost:${toString config.services.netbird.server.signal.port}
          }

          # Management API
          handle /api/* {
            reverse_proxy localhost:${toString config.services.netbird.server.management.port}
          }

          # Management WebSocket
          handle /ws-proxy/management* {
            reverse_proxy localhost:${toString config.services.netbird.server.management.port}
          }

          # Management gRPC
          handle /management.ManagementService/* {
            reverse_proxy h2c://localhost:${toString config.services.netbird.server.management.port}
          }

          # Dashboard (catch-all)
          handle {
            try_files {path} {path}.html {path}/ /index.html
            file_server
          }

          header * {
            Strict-Transport-Security "max-age=3600; includeSubDomains; preload"
            X-Frame-Options "SAMEORIGIN"
            X-Content-Type-Options "nosniff"
            X-XSS-Protection "1; mode=block"
            Referrer-Policy strict-origin-when-cross-origin
          }
        '';
      };
    };
  };
}
