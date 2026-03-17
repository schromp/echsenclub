{ config, ... }:
{
  services.caddy = {
    enable = true;
    email = "server@echsen.club";
    virtualHosts = {
      "lldap.echsen.club".extraConfig = ''
        @netbird {
          remote_ip 100.74.0.0/16
        }

        # Only proxy if the IP matches
        handle @netbird {
          reverse_proxy http://127.0.0.1:3890
        }

        # Fallback handle for everyone else
        handle {
          respond "Forbidden" 403
        }
      '';
      "lldap-admin.echsen.club".extraConfig = ''
        @netbird {
          remote_ip 100.74.0.0/16
        }

        # Only proxy if the IP matches
        handle @netbird {
          reverse_proxy http://127.0.0.1:17170
        }

        # Fallback handle for everyone else
        handle {
          respond "Forbidden" 403
        }
      '';
      "sso2.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:9091
      '';
      "netbird.echsen.club" = {
        extraConfig = ''
          root * ${config.services.netbird.server.dashboard.finalDrv}

          # Relay (WebSocket)
          handle /relay* {
            reverse_proxy [::1]:33080
          }

          # Signal WebSocket
          handle /ws-proxy/signal* {
            reverse_proxy [::1]:8012
          }

          # Signal gRPC (h2c for plaintext HTTP/2)
          handle /signalexchange.SignalExchange/* {
            reverse_proxy h2c://[::1]:${toString config.services.netbird.server.signal.port}
          }

          # Management API
          handle /api/* {
            reverse_proxy [::1]:${toString config.services.netbird.server.management.port}
          }

          # Management WebSocket
          handle /ws-proxy/management* {
            reverse_proxy [::1]:${toString config.services.netbird.server.management.port}
          }

          # Management gRPC
          handle /management.ManagementService/* {
            reverse_proxy h2c://[::1]:${toString config.services.netbird.server.management.port}
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
      "ha.echsen.club".extraConfig = ''
        @netbird {
          remote_ip 100.74.0.0/16
        }

        # Only proxy if the IP matches
        handle @netbird {
          reverse_proxy http://100.74.252.10:8123
        }

        # Fallback handle for everyone else
        handle {
          respond "Forbidden" 403
        }
      '';
    };
  };
}
