{ ... }:
{
  services.caddy = {
    enable = true;
    # package = pkgs.caddy.withPlugins {
    #   plugins = [ "github.com/caddy-dns/bunny@v1.2.0" ];
    #   hash = "sha256-OkyyPKPKu5C4cASU3r/Uw/vtCVMNRVBnAau4uu+WVp8=";
    # };

    globalConfig = ''
      servers {
        protocols h1 h2c h2 h3
      }
    '';
    virtualHosts = {
      "sso.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:8080
      '';
      "sso-admin.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:8080
      '';
      "grafana.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:3000
      '';
      "knot.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:5555
      '';
      # This seems wrong?
      "spindle.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:5555
      '';
      "jellyswarm.echsen.club".extraConfig = ''
        @netbird {
          remote_ip 100.74.0.0/16
        }

        # Only proxy if the IP matches
        handle @netbird {
          reverse_proxy http://127.0.0.1:3030
        }

        # Fallback handle for everyone else
        handle {
          respond "Forbidden" 403
        }
      '';
    };
  };
}
