{...}: {
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
}
