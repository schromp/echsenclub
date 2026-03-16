{config, ...}: {
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
      "matrix.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:3000
        # TODO
      '';
      "knot.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:5555
      '';
      # This seems wrong?
      "spindle.echsen.club".extraConfig = ''
        reverse_proxy http://127.0.0.1:5555
      '';
      "jellyswarm.echsen.club".extraConfig = ''
        bind 100.117.81.56
        reverse_proxy http://127.0.0.1:3030
      '';
      "ha.echsen.club".extraConfig = ''
        bind 100.117.81.56
        reverse_proxy http://100.117.246.32:8123
      '';
    };
  };
}
