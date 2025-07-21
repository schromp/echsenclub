{...}: {
  clan.core.vars.generators = {
    "netbird-services-setup-key" = {
      prompts.netbird-services-setup-key.description = "The zitadel client secret for the netbird user";
      prompts.netbird-services-setup-key.persist = true;

      files.netbird-services-setup-key = {
        secret = false;
      };
      share = true;
    };
  };
}
