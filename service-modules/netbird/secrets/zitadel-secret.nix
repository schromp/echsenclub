{pkgs, ...}: {
  clan.core.vars.generators = {
    "netbird-zitadel-client-secret" = {
      prompts.netbird-zitadel-client-secret.description = "The zitadel client secret for the netbird user";
      prompts.netbird-zitadel-client-secret.persist = true;

      files.netbird-zitadel-client-secret = {
        secret = true;
      };
    };
  };
}
