{...}: {
  services.netbird = {
    enable = true;
    server = {
      enable = true;
      domain = "netbird.echsen.club";
      management = {
        oidcConfigEndpoint = "http://zitadel.echsen.club/.well-known/openid-configuration";
        turnDomain = "netbird.echsen.club";
      };
      dashboard = {
        settings = {
          AUTH_AUTHORITY = "zitadel.echsen.club";
          AUTH_CLIENT_ID = "317716785199644716";
          NETBIRD_DISABLE_LETSENCRYPT = true;
          # client secret = Amu0XMw13NQ3xOajlYaYfnVUqELR5IieGrLmi1pyiZznGRyuKk4GAzxWFZgKYjlX
        };
      };
      #   coturn = {
      #     enable = true;
      #   };
    };
  };
}
