{config, ...}: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "turn-cloudy.netbird.echsen.club" = {
        useACMEHost = "turn-cloudy.netbird.echsen.club";
        forceSSL = true;
        http2 = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8013";
          proxyWebsockets = true;
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "server@echsen.club";

    certs."turn.netbird.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
  };
}
