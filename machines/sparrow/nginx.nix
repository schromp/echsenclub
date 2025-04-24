{clan-core, ...}: {
  imports = [
    clan-core.clanModules.nginx
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "jellyfin.echsen.club" = {
        enableACME = false;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
      "arm.echsen.club" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:28982";
          proxyWebsockets = true;
        };
      };
    };
  };
  # clan.nginx.acme.email = "lennart@koziollek.com";
}
