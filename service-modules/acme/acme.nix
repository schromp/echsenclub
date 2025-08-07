{
  _class = "clan.service";
  manifest.name = "acme";
  roles.default = {
    interface = {lib, ...}: {
      options = {
        domains = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "List of domains to obtain certificates for";
        };
        email = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Email address to use for ACME account registration";
        };
        acceptTerms = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to accept the ACME terms of service";
        };
        group = lib.mkOption {
          type = lib.types.str;
          default = "nginx";
          description = "Group running the ACME client";
        };
      };
    };

    perInstance = {settings, ...}: {
      nixosModule = {
        config,
        lib,
        ...
      }: {
        security.acme = {
          acceptTerms = settings.acceptTerms;
          defaults.email = settings.email;

          certs = lib.genAttrs settings.domains (domain: {
            group = "nginx";
            dnsProvider = "cloudflare";
            environmentFile = config.clan.core.vars.generators."acme-cloudflare-api-key".files."acme-cf-env".path;
          });
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
            share = true;
          };
        };
      };
    };
  };
}
