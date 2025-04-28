{
  clan-core,
  pkgs,
  config,
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "jellyfin.echsen.club" = {
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
      "netbird.echsen.club" = {
        useACMEHost = "zitadel.echsen.club";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:28982";
          proxyWebsockets = true;
        };
      };
      "zitadel.echsen.club" = {
        useACMEHost = "zitadel.echsen.club";
        forceSSL = true;
        locations."/" = {
          extraConfig = ''
            grpc_pass grpc://127.0.0.1:8082;
            grpc_set_header Host $host;
          '';
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "server@echsen.club";

    certs."zitadel.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
    certs."netbird.echsen.club" = {
      group = "nginx";
      dnsProvider = "cloudflare";
      environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
    };
  };

  clan.core.vars.generators = {
    "acme-cloudflare-api-key" = {
      prompts.cf-api-key.description = "The cloudflare api key";
      prompts.cf-api-key.type = "hidden";
      prompts.cf-api-key.persist = false;

      prompts.cf-email.description = "The email of the cf account";
      prompts.cf-email.persist = false;

      script = ''
        {
          printf "CF_DNS_API_TOKEN="; cat "$prompts/cf-api-key"; echo
          printf "CF_ZONE_API_TOKEN="; cat "$prompts/cf-api-key"; echo
          printf "CF_API_EMAIL=";  cat "$prompts/cf-email";  echo
        } > "$out/acme-cf-env"
      '';

      files.acme-cf-env = {
        secret = true;
      };
    };
  };
}
