{...}: {
  clan.core.vars.generators = {
    "netbird-services-setup-key" = {
      prompts.netbird-services-setup-key.description = "The zitadel client secret for the netbird user";
      prompts.netbird-services-setup-key.persist = true;

      files.netbird-services-setup-key = {
        secret = true;
      };

      share = true;
      # script = ''
      #   cat > "$out"/secret-envs <<EOF
      #     NB_SETUP_KEY=$(cat $prompts/netbird-services-setup-key)
      #   EOF
      # '';
    };
  };
}
