{libC,  ... }:
{
  services.caddy = {
    enable = true;

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
    };
  };
}
