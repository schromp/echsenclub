{ ... }:
{
  services.caddy = {
    enable = true;
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
    };
  };
}
