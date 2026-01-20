{config, pkgs, ...}: {
  services.caddy = {
    enable = true;
    # package = pkgs.caddy.withPlugins {
    #   plugins = [ "github.com/caddy-dns/bunny@v1.2.0" ];
    #   hash = "sha256-OkyyPKPKu5C4cASU3r/Uw/vtCVMNRVBnAau4uu+WVp8="; 
    # };
    virtualHosts = {
      "sso.echsen.club".extraConfig = ''
        reverse_proxy http://localhost:8080
      '';
      "sso-admin.echsen.club".extraConfig = ''
        reverse_proxy http://localhost:8080
      '';
      "grafana.echsen.club".extraConfig = ''
        reverse_proxy http://localhost:3000
      '';
      "matrix.echsen.club".extraConfig = ''
        reverse_proxy http://localhost:3000
        # TODO
      '';
      "knot.echsen.club".extraConfig = ''
        reverse_proxy http://localhost:5555
      '';
      # This seems wrong?
      "spindle.echsen.club".extraConfig = ''
        reverse_proxy http://localhost:5555
      '';
      # "maubot.echsen.club".extraConfig = ''
      #   reverse_proxy http://localhost:5555
      # '';
      "netbird.echsen.club".extraConfig = ''
        root * ${config.services.netbird.server.dashboard.finalDrv}

        # route FORCES Caddy to follow this exact order, no reordering!
        route {
            # 1. API & Backends (Top priority)
            # Match these first. If matched, Caddy proxies and STOPS.
            reverse_proxy /api* 127.0.0.1:8011
            reverse_proxy /management.ManagementService/* h2c://127.0.0.1:8011
            reverse_proxy /signalexchange.SignalExchange/* h2c://127.0.0.1:8012
            reverse_proxy /relay* 127.0.0.1:33080

            # 2. Static Assets
            # If it's a real file (CSS, JS, Image), serve it and STOP.
            file_server

            # 3. SPA Fallback (The Catch-All)
            # If we reach this point, it wasn't an API call and isn't a real file.
            # It must be a React route (like /peers), so serve index.html.
            try_files {path} /index.html
        }
      '';
    };
  };
}
